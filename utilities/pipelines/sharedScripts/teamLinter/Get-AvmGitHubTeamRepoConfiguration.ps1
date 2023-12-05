Function Get-AvmGitHubTeamRepoConfiguration {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Organization,

        [Parameter(Mandatory)]
        [string]$TeamName,

        [Parameter(Mandatory)]
        [string]$RepoName

    )
    # use githubCLI to get all teams in Azure organization


    try {
        $rawJson = gh api orgs/$Organization/teams/$TeamName/repos
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

    if ($teamName -like "*owners*") {
        $expectedPermission = "admin"
        if ($filteredJson.role_name -ne $expectedPermission) {
            $findings = "Team: $TeamName is not configured with the expected permission: $expectedPermission on Repo: $repoName"
        }
        else {
            Write-Output "Good News! Repo: $repoName is configured with the expected permission: $expectedPermission"
            $findings = "Success"
        }
    }
    elseif ($teamName -like "*contributors*") {
        $expectedPermission = "write"
        if ($filteredJson.role_name -ne $expectedPermission) {
            $findings = "Team: $TeamName is not configured with the expected permission: $expectedPermission on Repo: $repoName"
        }
        else {
            Write-Output "Good News! Repo: $repoName is configured with the expected permission: $expectedPermission"
            $findings = "Success"
        }
    }
    return $findings

}
