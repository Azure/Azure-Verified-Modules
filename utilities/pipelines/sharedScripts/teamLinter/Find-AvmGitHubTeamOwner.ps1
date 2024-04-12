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
