<#
.SYNOPSIS
    Checks if a GitHub issue exists for a given team. If not, creates a new issue.

.DESCRIPTION
    Checks if a GitHub issue exists for a given team. If not, creates a new issue.

.PARAMETER TeamName
    The name of the team to check.

.PARAMETER Owner
    The owner of the team to check.

.PARAMETER ValidationError
    The validation error to add to the issue.

.PARAMETER CreateIssues
    Switch to create issues if they do not exist.

.EXAMPLE
    Set-AvmGitHubTeamsIssue -TeamName 'MyTeam' -Owner 'MyOwner' -ValidationError 'MyValidationError' -CreateIssues

    Checks if an issue exists for the team 'MyTeam' with the owner 'MyOwner'. If not, creates a new issue with the validation error 'MyValidationError'.

.EXAMPLE
    Set-AvmGitHubTeamsIssue -TeamName 'MyTeam' -Owner 'MyOwner' -ValidationError 'MyValidationError'

    Checks if an issue exists for the team 'MyTeam' with the owner 'MyOwner'. If not, does not create a new issue.
#>

function Set-AvmGitHubTeamsIssue {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string]$TeamName,
        [Parameter(Mandatory)]
        [string]$Owner,
        [Parameter(Mandatory)]
        [string]$ValidationError,
        [Parameter(Mandatory)]
        [string]$ResolutionInfo,
        [Parameter(Mandatory)]
        [switch]$CreateIssues
    )

    # Load used functions
    . (Join-Path $PSScriptRoot "Find-GitHubIssue.ps1")
    . (Join-Path $PSScriptRoot "New-AvmGitHubTeamsIssue.ps1")

    # Extract Gh Handle from Owner String
    $Owner = $Owner.Split(" ")[0]

    $title = "[GitHub Team Issue] ``$TeamName``"
    $bodyAutoDisclaimer = "*This issue was automatically created by the AVM Team Linter. If this issue has been created by mistake, please reach out to the AVM Team by leaving a comment on this issue.*"
    $bodyAdvisoryNote = "**NOTE**: `n`n- The title of this issue **MUST** not be changed to prevent duplication of issues. `n- This issue **MUST** be closed by the module owner, once the issue has been addressed."
    $teamError = "# Description `nThe AVM Team Linter has found an issue with the following GitHub Team."
    $teamTable = "| Team Name | Owner | Issue |`n| --- | --- | --- |`n| $TeamName | $Owner | $validationError |"
    $resolutionSegment = "# Resolution `n$ResolutionInfo"
    $body = "$teamError`n`n$teamTable`n`n$resolutionSegment`n`n$bodyAutoDisclaimer`n`n$bodyAdvisoryNote"

    $issues = Find-GithubIssue -title $title

    if (($issues -like "No match found*") -And $CreateIssues) {
        Write-Output "No issue found for: $($title), Creating new issue."
        try {
          if ($PSCmdlet.ShouldProcess($TeamName, "Create GitHub Issue")) {
            New-AvmGitHubTeamsIssue -title $title -assignee $Owner -body $body
          }
        }
        catch {
            Write-Error "Unable to create issue. Check network connection."
            return $Error
        }
    }
    elseif (($issues -like "No match found*") -And !$CreateIssues) {
        Write-Verbose "New issue should be created for: $($title) with $($body)"
        Write-Verbose "Issue not created due to -CreateIssues switch not being used. Performing What-If"
        New-AvmGitHubTeamsIssue -title $title -assignee $Owner -body $body -WhatIf

    }
    else {
        Write-Output "Search Output: $($issues)"
    }
}
