[CmdletBinding()]
param(
  [string] $RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\..')),
  [string] $HugoPath = 'hugo'
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false
$null = Get-Command $HugoPath -ErrorAction Stop
$testRoot = Join-Path ([IO.Path]::GetTempPath()) "avm-terraform-registry-$([guid]::NewGuid())"
$server = $null

try {
  $partialsPath = Join-Path $testRoot 'layouts\partials'
  $null = New-Item -ItemType Directory -Path $partialsPath -Force
  Copy-Item (Join-Path $RepositoryRoot 'docs\layouts\partials\terraform-registry-versions.html') $partialsPath
  Set-Content -Path (Join-Path $testRoot 'layouts\index.html') -Value @'
{{- partial "terraform-registry-versions.html" (dict "url" site.Params.registryUrl "moduleStatus" site.Params.moduleStatus) | jsonify | safeHTML -}}
'@

  $server = Start-Job -ScriptBlock {
    $ErrorActionPreference = 'Stop'
    $portReservation = [Net.Sockets.TcpListener]::new([Net.IPAddress]::Loopback, 0)
    $portReservation.Start()
    $port = $portReservation.LocalEndpoint.Port
    $portReservation.Stop()
    $listener = [Net.HttpListener]::new()
    $listener.Prefixes.Add("http://127.0.0.1:$port/")
    $listener.Start()
    Write-Output "http://127.0.0.1:$port"

    try {
      $pendingContext = $listener.GetContextAsync()
      while ($listener.IsListening) {
        if (-not $pendingContext.Wait(100)) {
          continue
        }
        $context = $pendingContext.Result
        $status = 200
        $body = '{"modules":[{"versions":[{"version":"1.0.0"},{"version":"1.1.0-pre.1"},{"version":"1.1.0"}]}]}'
        switch ($context.Request.Url.AbsolutePath) {
          '/missing' {
            $status = 404
            $body = '{"errors":["Not Found"]}'
          }
          '/rate-limited' {
            $status = 429
            $body = '{"errors":["Too Many Requests"]}'
          }
          '/unavailable' {
            $status = 503
            $body = '{"errors":["Service Unavailable"]}'
          }
          '/invalid-json' {
            $body = '{invalid'
          }
        }
        $bytes = [Text.Encoding]::UTF8.GetBytes($body)
        $context.Response.StatusCode = $status
        $context.Response.ContentType = 'application/json'
        $context.Response.ContentLength64 = $bytes.Length
        $context.Response.OutputStream.Write($bytes, 0, $bytes.Length)
        $context.Response.Close()
        $pendingContext = $listener.GetContextAsync()
      }
    }
    finally {
      $listener.Close()
    }
  }

  $deadline = [datetime]::UtcNow.AddSeconds(15)
  $baseUrl = $null
  while (-not $baseUrl) {
    $baseUrl = Receive-Job $server
    if ($server.State -in @('Completed', 'Failed', 'Stopped') -or [datetime]::UtcNow -ge $deadline) {
      throw 'The local Terraform Registry test server did not start.'
    }
    if (-not $baseUrl) {
      Start-Sleep -Milliseconds 100
    }
  }

  $cases = @(
    @{ Path = '/published'; Status = 'Available'; Versions = @('1.0.0', '1.1.0-pre.1', '1.1.0') }
    @{ Path = '/published'; Status = 'Orphaned'; Versions = @('1.0.0', '1.1.0-pre.1', '1.1.0') }
    @{ Path = '/published'; Status = 'Deprecated'; Versions = @('1.0.0', '1.1.0-pre.1', '1.1.0') }
    @{ Path = '/missing'; Status = 'Orphaned'; Versions = @(); Warning = 'No published Terraform Registry module found' }
    @{ Path = '/missing'; Status = 'Deprecated'; Versions = @(); Warning = 'No published Terraform Registry module found' }
    @{ Path = '/missing'; Status = 'Available'; Error = 'Unable to get remote resource' }
    @{ Path = '/unavailable'; Status = 'Available'; Error = '503' }
    @{ Path = '/unavailable'; Status = 'Orphaned'; Error = '503' }
    @{ Path = '/unavailable'; Status = 'Deprecated'; Error = '503' }
    @{ Path = '/rate-limited'; Status = 'Orphaned'; Error = '429' }
    @{ Path = '/invalid-json'; Status = 'Orphaned'; Error = 'unmarshal' }
  )

  foreach ($case in $cases) {
    Set-Content -Path (Join-Path $testRoot 'hugo.toml') -Value @"
baseURL = 'http://localhost/'
disableKinds = ['taxonomy', 'term', 'RSS', 'sitemap']
[params]
registryUrl = '$baseUrl$($case.Path)'
moduleStatus = '$($case.Status)'
"@
    $log = (& $HugoPath --source $testRoot --cacheDir (Join-Path $testRoot 'cache') --ignoreCache --logLevel warn 2>&1) -join "`n"
    $exitCode = $LASTEXITCODE
    $caseName = "$($case.Status) $($case.Path)"
    if ($case.Error) {
      if ($exitCode -eq 0 -or $log -notmatch [regex]::Escape($case.Error)) {
        throw "Expected '$caseName' to fail with '$($case.Error)'. Exit code: $exitCode`n$log"
      }
      continue
    }
    if ($exitCode -ne 0) {
      throw "Expected '$caseName' to build successfully. Exit code: $exitCode`n$log"
    }
    $versions = @(Get-Content -Raw (Join-Path $testRoot 'public\index.html') | ConvertFrom-Json)
    if (($versions -join ',') -cne ($case.Versions -join ',')) {
      throw "Unexpected versions for '$caseName': $($versions -join ',')."
    }
    if ($case.Warning -and $log -notmatch [regex]::Escape($case.Warning)) {
      throw "Expected a missing-publication warning for '$caseName'.`n$log"
    }
  }

  Write-Output "Terraform Registry version handling passed all $($cases.Count) cases."
}
finally {
  if ($server) {
    Stop-Job $server
    Remove-Job $server
  }
  if (Test-Path -LiteralPath $testRoot) {
    Remove-Item -LiteralPath $testRoot -Recurse -Force
  }
}
