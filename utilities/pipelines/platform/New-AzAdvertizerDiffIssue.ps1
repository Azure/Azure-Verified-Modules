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

.PARAMETER Workflow
Optional. The name of the workflow file to create the issue for.

.EXAMPLE
New-AzAdvertizerDiffIssue -RepositoryOwner 'Azure' -RepositoryName 'Azure-Verified-Modules' -Workflow 'platform.new-AzAdvertizer-diff-issue.yml'

TODO: Check the last 100 workflow runs in the repository 'owner/repo01' that happened in the last 2 days. If the workflow name is 'Pipeline 01', then ignore the workflow run.

.NOTES
Will be triggered by the workflow platform.new-AzAdvertizer-diff-issue.yml
#>
function New-AzAdvertizerDiffIssue {
  [CmdletBinding(SupportsShouldProcess)]
  param (
    [Parameter(Mandatory = $false)]
    [string] $RepositoryOwner = 'Azure',

    [Parameter(Mandatory = $false)]
    [string] $RepositoryName = 'Azure-Verified-Modules',

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName,

    [Parameter(Mandatory = $false)]
    [string] $Workflow = 'platform.new-AzAdvertizer-diff-issue.yml'
  )

  # Loading helper functions
  . (Join-Path $RepoRoot 'utilities' 'tools' 'platform' 'helper' 'Get-AzAdvertizerData.ps1')

  $Repo = "$RepositoryOwner/$RepositoryName"
  $latestWorkflowRunId = gh run list --repo $Repo --workflow $Workflow --branch 'main' --limit 2 --json 'databaseId' | ConvertFrom-JSON | Select-Object -Last 1 -ExpandProperty 'databaseId'

  if (-not $latestWorkflowRunId) {
    throw "No workflow run found for workflow '$Workflow' in repository '$Repo'."
  }

  # get artifact (AzAdvertizerData.csv) from the latest workflow run
  $artifact = gh run download $latestWorkflowRunId --repo $Repo --dir './old' --name 'AzAdvertizerData.csv' 2>&1

  if ($null -eq $artifact) {
    Write-Host "Downloaded artifact: $artifact"
    $issuesCreated = 0
    $addedData = Get-AzAdvertizerDataDiff -Path './old/AzAdvertizerData.csv'

    if ($addedData.Count -gt 0) {
      $issueName = "AzAdvertizer data changes detected"
      $body = Format-AzAdvertizerDataDiff -DiffData $addedData

      if ($PSCmdlet.ShouldProcess("Issue [$issueName]", 'Create')) {
        $issueUrl = gh issue create --title $issueName --body $body --repo $repo
        gh issue edit $issueUrl --repo $repo --add-assignee 'jeanchg'
      }
      $issuesCreated++
    }
  }
  Write-Verbose ('[{0}] issue(s){1} created' -f $issuesCreated, ($WhatIfPreference ? ' would have been' : '')) -Verbose

  # download new AzAdvertizer data for artifact step
  mkdir new
  Export-AzAdvertizerDataToCsv -Path './new/AzAdvertizerData.csv'
}
