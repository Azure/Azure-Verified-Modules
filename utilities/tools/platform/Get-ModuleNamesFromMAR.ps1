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

Returns the list of module names in the MAR file as an array of strings.

#>
function Get-ModuleNamesFromMAR {

  [CmdletBinding()]
  [OutputType([string[]])]
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

  $marFileModuleNames = [System.Collections.Generic.List[string]]::new()
  try {
    foreach ($match in [regex]::Matches($marFileContent, '(?m)^\s*-\s*name:\s*(?<name>[^\r\n]+)')) {
      $moduleName = $match.Groups['name'].Value.Trim() -replace '^public/bicep/', ''
      $null = $marFileModuleNames.Add($moduleName)
    }
  }
  catch {
    throw "Failed to parse module names from MAR file. Error: $($_.Exception.Message)"
  }

  return $marFileModuleNames.ToArray()
}

function Set-LocalMARFileContent {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory, HelpMessage = 'Provide the path to the local MAR file copy.')]
    [string] $LocalMARFilePath,

    [Parameter(Mandatory, HelpMessage = 'Provide the new content for the local MAR file.')]
    [string[]] $FileContent
  )

  $jsonContent = $FileContent | ConvertTo-Json
  if ($PSCmdlet.ShouldProcess($LocalMARFilePath, 'Update local MAR file content')) {
    $null = New-Item -Path $LocalMARFilePath -Value ($jsonContent | Out-String) -Force
    Write-Verbose "File [$LocalMARFilePath] updated" -Verbose
  }
}
