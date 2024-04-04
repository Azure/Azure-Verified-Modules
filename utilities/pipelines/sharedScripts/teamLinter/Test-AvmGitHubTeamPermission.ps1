Function Test-AvmGitHubTeamPermission {
    [CmdletBinding()]
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
