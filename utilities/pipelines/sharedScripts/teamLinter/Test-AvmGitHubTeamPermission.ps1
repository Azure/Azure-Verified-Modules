<#
.SYNOPSIS
  This function checks if a team has the expected permission on a repo.

.DESCRIPTION
  This function checks if a team has the expected permission on a repo.

.PARAMETER Organization
  The name of the GitHub Organization.

.PARAMETER TeamName
  The name of the GitHub Team.

.PARAMETER RepoName
  The name of the GitHub Repo.

.PARAMETER ExpectedPermission
  The expected permission for the team on the repo. `Admin | Write | Read | Triage | Maintain | None`

.EXAMPLE
  Test-AvmGitHubTeamPermission -Organization "myOrg" -TeamName "myTeam" -RepoName "myRepo" -ExpectedPermission "Admin"

  Test if 'myTeam' has 'Admin' permission on 'myRepo' in 'myOrg'

#>

function Test-AvmGitHubTeamPermission {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory)]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$TeamName,

        [Parameter(Mandatory)]
        [string]$RepoName,

        [Parameter(Mandatory)]
        [string]$ExpectedPermission
    )


    try {
        $rawJson = gh api orgs/$Organization/teams/$TeamName/repos --paginate
        $formattedJson = ConvertFrom-Json $rawJson
        try {
            $filteredJson = $formattedJson | Where-Object { $_.name -like $repoName }
        }
        catch {
            Write-Error "Unable to find repo: $repoName configured for team: $TeamName"
        }
    }
    catch {
        Write-Error "Error: $_"
    }


    if ($filteredJson.role_name -ne $ExpectedPermission) {
        $findings = "Team: $TeamName is not configured with the expected permission: $ExpectedPermission on Repo: $repoName"
    }
    else {
        Write-Output "Good News! Repo: $repoName is configured with the expected permission: $ExpectedPermission"
        $findings = "Success"
    }

    return $findings
}
