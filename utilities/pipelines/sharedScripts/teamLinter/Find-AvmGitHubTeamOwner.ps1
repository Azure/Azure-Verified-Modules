<#
.SYNOPSIS
    This function is used to find the owner of a GitHub team and Validate it with the expected owner.

.DESCRIPTION
    This function is used to find the owner of a GitHub team and Validate it with the expected owner.

.PARAMETER Organization
    The name of the GitHub Organization.

.PARAMETER TeamName
    The name of the GitHub Team.

.PARAMETER OwnerGitHubHandle
    The GitHub handle of the expected owner of the team.

.EXAMPLE
  Find-AvmGitHubTeamOwner -Organization "myOrg" -TeamName "myTeam" -OwnerGitHubHandle "myOwner"

  Check if 'myOwner' is the owner of 'myTeam' in 'myOrg'

  #>



function Find-AvmGitHubTeamOwner {
  [CmdletBinding()]
  [OutputType([System.String])]
  param (
    [Parameter(Mandatory)]
    [string]$Organization,

    [Parameter(Mandatory)]
    [string]$TeamName,

    [Parameter(Mandatory)]
    [string]$OwnerGitHubHandle
  )


  try {
    $rawJson = gh api orgs/$Organization/teams/$TeamName/members --paginate
    $formattedJson = ConvertFrom-Json $rawJson
    $filteredJson = $formattedJson | Where-Object { $_.login -like $OwnerGitHubHandle }
  }
  catch {
    Write-Error "Error: $_"
  }


  if ($null -eq $filteredJson) {
    $findings = "Team: $TeamName is not configured with the expected owner: $OwnerGitHubHandle"
  }
  else {
    Write-Output "Good News! Team $TeamName is configured with the correct owner: $OwnerGitHubHandle"
    $findings = "Success"
  }

  return $findings
}
