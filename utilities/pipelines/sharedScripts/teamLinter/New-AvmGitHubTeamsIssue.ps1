function New-AVMGitHubTeamsIssue {
    [CmdletBinding(SupportsShouldProcess)]
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
    # Validate Auth Status
    gh auth status
    if ($? -eq $false) {
        Write-Error "You are not authenticated to GitHub. Please run 'gh auth login' to authenticate."
        exit 1
    }
    try {
        # Construct the full command
        gh issue create --title $title --body $body --assignee $assignee --label "Type: AVM :a: :v: :m:" --label "Needs: Triage :mag:"
    }
    catch {
        Write-Error "Unable to create issue. Check network connection."
        return $Error
    }
}
