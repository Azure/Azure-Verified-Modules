<#
.SYNOPSIS
Check if a module in a given path does exist in the MAR file. Returns $true or $false.

.DESCRIPTION
Check if a module in a given path does exist in the MAR file. Only then, it can be published to the MCR.

.PARAMETER GitHubToken
Mandatory. A GitHub token with read access to the MAR repository (microsoft/mcr).

.PARAMETER Owner
Mandatory. The Organisation, where the repository is located. Default is "Microsoft".

.PARAMETER Repo
Mandatory. The repository name. Default is "mcr".

.EXAMPLE
Get-ModuleNamesFromMAR -GitHubToken $env:MAR_REPO_ACCESS_PAT -Owner 'Microsoft' -Repo 'mcr' -Verbose

#>
function Get-ModuleNamesFromMAR {

  [CmdletBinding()]
  param (
    [Parameter(Mandatory, HelpMessage = 'Provide a GitHub token (PAT for testing or GitHub App token for production) with read access to the MAR repository (microsoft/mcr).')]
    [string] $GitHubToken,

    [Parameter(Mandatory, HelpMessage = 'Provide the Organisation, where the repository is located. Default is "Microsoft".')]
    [string] $Owner,

    [Parameter(Mandatory, HelpMessage = 'Provide the repository name. Default is "mcr".')]
    [string] $Repo
  )

  ##################################
  ##   Confirm module tag known   ##
  ##################################
  $marFileUrl = "https://raw.githubusercontent.com/$Owner/$Repo/refs/heads/main/teams/bicep/bicep.yml"
  $headers = @{
    Authorization = "Bearer $GitHubToken"
    Accept        = 'application/vnd.github.v3.raw'
    'User-Agent'  = 'AVM-Publish-Pipeline'
  }

  $marFileContent = $null

  try {
    $marFileContent = (Invoke-WebRequest -Uri $marFileUrl -Headers $headers -ErrorAction Stop).Content
  }
  catch {
    throw "Failed to fetch MAR file from [$marFileUrl]. Error: $($_.Exception.Message)"
  }

  $marFileModuleNames = @()
  try {
    # if (Get-Command -Name 'ConvertFrom-Yaml' -ErrorAction SilentlyContinue) {
    #   $marObject = $marFileContent | ConvertFrom-Yaml -ErrorAction Stop
    #   $marFileModuleNames = @($marObject.repos | Where-Object { $null -ne $_.name } | ForEach-Object { $_.name -replace '^public/bicep/', '' })
    # }

    $marFileModuleNames = @([regex]::Matches($marFileContent, '(?m)^\s*-\s*name:\s*(?<name>[^\r\n]+)') | ForEach-Object {
        $_.Groups['name'].Value.Trim() -replace '^public/bicep/', ''
      })
  }
  catch {
    throw "Failed to parse module names from MAR file. Error: $($_.Exception.Message)"
  }

  return $marFileModuleNames
}

function Set-LocalMARFileContent {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory, HelpMessage = 'Provide the path to the local MAR file copy.')]
    [string] $LocalMARFilePath,

    [Parameter(Mandatory, HelpMessage = 'Provide the new content for the local MAR file.')]
    [string[]] $FileContent
  )

  if ($PSCmdlet.ShouldProcess("File in path [$LocalMARFilePath]", 'Overwrite')) {
    $jsonContent = $FileContent | ConvertTo-Json
    # Set-Content -Path $LocalMARFilePath -Value $jsonContent -Encoding utf8 -Force
    New-Item -Path $LocalMARFilePath -Value ($jsonContent | Out-String) -Force
    Write-Verbose "File [$LocalMARFilePath] updated" -Verbose
  }
}
