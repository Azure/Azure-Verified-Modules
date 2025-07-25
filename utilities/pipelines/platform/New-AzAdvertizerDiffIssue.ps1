<#
.SYNOPSIS
Creating an issue, if data in AzAdvertizer (PSRule, APRL and Advisor) changed compared to the last run of the platform.new-AzAdvertizer-diff-issue.yml workflow.

.DESCRIPTION
Creating an issue, if data in AzAdvertizer (PSRule, APRL and Advisor) changed compared to the last run of the platform.new-AzAdvertizer-diff-issue.yml workflow.

.PARAMETER RepositoryOwner
Optional. The GitHub organization to run the workfows in.

.PARAMETER RepositoryName
Optional. The GitHub repository to run the workfows in.

.PARAMETER RepoRoot
Optional. Path to the root of the repository.

.PARAMETER PersonalAccessToken
Optional. The PAT to use to interact with either GitHub. If not provided, the script will use the GitHub CLI to authenticate.

.PARAMETER WorkflowId
Optional. The ID of the workflow to create the issue for.

.EXAMPLE
New-AzAdvertizerDiffIssue -Repo 'owner/repo01'

Check the last 100 workflow runs in the repository 'owner/repo01' that happened in the last 2 days. If the workflow name is 'Pipeline 01', then ignore the workflow run.

.NOTES
Will be triggered by the workflow platform.new-AzAdvertizer-diff-issue.yml
#>
function New-AzAdvertizerDiffIssue {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $false)]
    [string] $PersonalAccessToken,

    [Parameter(Mandatory = $false)]
    [string] $RepositoryOwner = 'Azure',

    [Parameter(Mandatory = $false)]
    [string] $RepositoryName = 'Azure-Verified-Modules',

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName,

    [Parameter(Mandatory = $true)]
    [string] $WorkflowId = '?????' # ID of the platform.new-AzAdvertizer-diff-issue.yml workflow
  )

  # Loading helper functions
  . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-AzAdvertizerData.ps1')
  . (Join-Path $RepoRoot 'utilities' 'pipelines' 'platform' 'helper' 'Get-GitHubWorkflowLatestRun.ps1')

  $baseInputObject = @{
    RepositoryOwner = $RepositoryOwner
    RepositoryName  = $RepositoryName
  }
  if ($PersonalAccessToken) {
    $baseInputObject['PersonalAccessToken'] = @{
      PersonalAccessToken = $PersonalAccessToken
    }
  }

  $latestWorkflowRun = Get-GitHubWorkflowLatestRun @baseInputObject -WorkflowId $WorkflowId
  $repo = "$RepositoryOwner/$RepositoryName"

  $issuesCreated = 0

  if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Create')) {
    $issueUrl = gh issue create --title $issueName --body $failedRunText --label "$avmLabel,$bugLabel" --repo $repo
  }
  $issuesCreated++

  Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, ($WhatIfPreference ? ' would have been' : '')) -Verbose
}
