function New-AVMGitHubTeamsIssue {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$title,
        [Parameter(Mandatory)]
        [string]$assignee,
        [Parameter(Mandatory)]
        [string]$body,
        [Parameter(Mandatory=$false)]
        [array]$labels
    )
    
    gh auth status  
    if ($? -eq $false) {
        Write-Error "You are not authenticated to GitHub. Please run 'gh auth login' to authenticate."
        exit 1
    }
    try {
        # Build the labels part of the command
        $joinedLabels = $labels | ForEach-Object { "--label $_" } -join ' '

        # Construct the full command
        gh issue create --title $title --body $body --assignee $assignee $joinedLabels
    }
    catch {
        Write-Error "Unable to create issue. Check network connection."
        return $Error
    }
}