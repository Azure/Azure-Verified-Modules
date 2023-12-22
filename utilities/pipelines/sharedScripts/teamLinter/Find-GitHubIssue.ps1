function Find-GithubIssue {
    [CmdletBinding()]
    [OutputType([System.String])]
    param (
        [Parameter(Mandatory)]
        [string]$title
    )

    $issueList = gh issue list --limit 500 --json number,title,assignees,labels,id | ConvertFrom-Json
    $issueDetails = $null

    foreach ($issueItem in $issueList) {
        if ($issueItem.title -eq $title) {
            $issueDetails = "$($issueItem.number) | $($issueItem.title) | $($issueItem.assignees.login)"
            Write-Output "Good News! Issue Found:: $($issueDetails)"
            return $issueDetails
        }
    }

    # If no match is found in the loop, return an empty string
    Write-Output "No match found for: $($title)"
    return $issueDetails
}
