function New-AVMGitHubTeamsIssue {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$title,
        [Parameter(Mandatory)]
        [string]$assignee,
        [Parameter(Mandatory)]
        [string]$body
    )

    # Validate effected module language
    if ($title -like '*bicep') {
        $languageLabel = "Language: Bicep :muscle:"
    }
    elseif ($title -like '*terraform') {
        $languageLabel = "Language: Terraform :globe_with_meridians:"
    }

    # Validate effected module class
    if ($title -like 'avm-res-*') {
        $classLabel = "Class: Resource Module :package:"
    }
    elseif ($title -like 'avm-ptn-*') {
        $classLabel = "Class: Pattern Module :package:"
    }

    # Validate Auth Status
    gh auth status
    if ($? -eq $false) {
        Write-Error "You are not authenticated to GitHub. Please run 'gh auth login' to authenticate."
        exit 1
    }
    try {
        # Construct the full command
        if ($PSCmdlet.ShouldProcess($title, "Create New GitHub Issue")) {
        gh issue create --title $title --body $body --assignee $assignee --label $languageLabel --label $classLabel --label "Type: Hygiene :broom:"
        }
    }
    catch {
        Write-Error "Unable to create issue. Check network connection."
        return $Error
    }
}
