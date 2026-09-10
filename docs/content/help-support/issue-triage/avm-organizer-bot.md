---
title: Azure Verified Modules GitHub App
linktitle: Azure Verified Modules GitHub App
description: Azure Verified Modules GitHub App for the Azure Verified Modules (AVM) program's repositories
---

## Overview

The **Azure Verified Modules GitHub App** is represented as a [GitHub App](https://github.com/apps/azure-verified-modules). This app automates various repository management tasks across the Azure Verified Modules program's repositories, including issue triage, pull request labeling, team validation, and documentation updates.

The bot operates by authenticating with GitHub using the GitHub App credentials (`TEAM_LINTER_APP_ID` and `TEAM_LINTER_PRIVATE_KEY`) and executing PowerShell scripts through scheduled workflows and/or event-triggered actions. Retain these credentials when retiring the team linter: the active AzAdvertizer issue automation also uses them.

{{% notice style="warning" %}}
The team linter below still validates legacy per-module GitHub teams and requires separate cleanup. Do not recreate those teams to satisfy the automation; module owners must follow [SNFR20]({{% siteparam base %}}/spec/SNFR20) instead. Legacy CSV team columns remain for compatibility with existing shared-repository consumers.
{{% /notice %}}

---

## AVM Repository Scripts

The following scripts are leveraged by the **[Azure Verified Modules GitHub App](https://github.com/apps/azure-verified-modules)** in the [AVM](https://aka.ms/AVM/repo) repository:

### 1. Invoke-AvmGitHubTeamLinter.ps1

**Purpose**: Validates GitHub team configurations against module ownership data from CSV indexes.

**Description**: This script compares the module indexes with existing GitHub Teams configuration to ensure proper team setup. It can validate Bicep parent team configurations, Terraform team permissions, and generate GitHub issues for any discrepancies found. The script supports filtering by module type (Resource/Pattern/Utility) and language (Bicep/Terraform), and can validate `-owner-` teams.

**Key Functionality**:
- Compares module ownership data from CSV files with GitHub team configurations
- Validates parent team configuration for Bicep module owner teams
- Verifies correct repository permissions for Terraform teams
- Creates GitHub issues for unmatched or misconfigured teams
- Closes resolved GitHub issues when team configurations are corrected

**Workflow**: [`github-teams-check-existence.yml`](https://github.com/Azure/Azure-Verified-Modules/blob/main/.github/workflows/github-teams-check-existence.yml) (currently disabled; when enabled, runs Monday-Friday at 15:00 UTC and on-demand). Update its legacy team checks before re-enabling it; unchanged, it would raise issues asking owners to recreate retired teams, not recreate the teams itself.

**Source Code**: [`Invoke-AvmGitHubTeamLinter.ps1`](https://github.com/Azure/Azure-Verified-Modules/blob/main/utilities/pipelines/sharedScripts/teamLinter/Invoke-AvmGitHubTeamLinter.ps1)

---

### 2. New-AzAdvertizerDiffIssue.ps1

**Purpose**: Monitors AzAdvertizer data changes and creates tracking issues.

**Description**: This script creates GitHub issues when data in AzAdvertizer (including PSRule, APRL, and Advisor) changes compared to the last workflow run. It downloads artifacts from previous workflow runs, compares the data to identify changes, and automatically creates issues with detailed diff information when new policy rules, advisories, or recommendations are detected.

**Key Functionality**:
- Downloads CSV artifacts from the latest workflow run
- Compares current AzAdvertizer data with previous data to detect changes
- Formats detected changes into readable GitHub issue format
- Creates GitHub issues for new PSRule, APRL, or Azure Advisor data
- Exports current data as artifacts for future comparisons

**Workflow**: [`platform.new-AzAdvertizer-diff-issue.yml`](https://github.com/Azure/Azure-Verified-Modules/blob/main/.github/workflows/platform.new-AzAdvertizer-diff-issue.yml) (runs weekly on Sundays at 3:00 AM and on-demand)

**Source Code**: [`New-AzAdvertizerDiffIssue.ps1`](https://github.com/Azure/Azure-Verified-Modules/blob/main/utilities/pipelines/platform/New-AzAdvertizerDiffIssue.ps1)

---

## BRM Repository Scripts

The following scripts are leveraged by the **[Azure Verified Modules GitHub App](https://github.com/apps/azure-verified-modules)** in the bicep-registry-modules ([BRM](https://aka.ms/BRM)) repository:

Module-specific routing uses the individual owners recorded in the [module indexes]({{% siteparam base %}}/indexes/bicep/), not `ModuleOwnersGHTeam` or membership of the shared Module Contributors team. The `Get-AvmModuleOwnerLogin.ps1` helper resolves `PrimaryModuleOwnerGHHandle` and `SecondaryModuleOwnerGHHandle`, inheriting ownership and orphan status through `ParentModule` for child modules. It normalizes and deduplicates handles and reports missing, duplicate, or invalid ownership metadata rather than treating it as an empty owner list.

### 1. Set-AvmGitHubIssueOwnerConfig.ps1

**Purpose**: Automatically assigns issues to appropriate module owners.

**Description**: This script processes GitHub issues in the BRM repository and automatically assigns them to the correct module owners based on the AVM CSV data. It notifies module owners via comments, assigns the issue to them, adds appropriate labels, and assigns issues to the AVM project board. The script handles both individual issue processing (when triggered by issue creation) and batch processing (when run on schedule).

**Key Functionality**:
- Matches issues to modules based on issue content and labels
- Retrieves module ownership information from AVM CSV indexes (Resource, Pattern, Utility)
- Automatically assigns issues to indexed individual module owners
- Preserves manual assignments and unassignments, and does not remove assignees when ownership cannot be resolved
- Posts notification comments mentioning the resolved individual owners
- Adds appropriate labels based on module type and status
- Assigns issues to GitHub project boards for tracking
- Handles orphaned modules by assigning to core team
- Tracks statistics on assignments and updates

**Workflow**: [`platform.set-avm-github-issue-owner-config.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.set-avm-github-issue-owner-config.yml) (runs on issue creation, weekly on Sundays at midnight, and on-demand)

**Source Code**: [`Set-AvmGitHubIssueOwnerConfig.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/platform/Set-AvmGitHubIssueOwnerConfig.ps1)

---

### 2. Set-AvmGitHubPrLabels.ps1

**Purpose**: Automatically labels pull requests based on reviewer requirements.

**Description**: This script evaluates non-draft pull requests using their changed files and module index ownership data. It requests individual module owners as reviewers where appropriate and applies labels to distinguish module owner review from core team review. It does not infer module ownership from requested reviewer teams.

**Key Functionality**:
- Skips draft pull requests
- Retrieves all changed files through pagination, including the original paths of renamed files
- Resolves module ownership from indexed primary and secondary owner handles, including parent-module inheritance
- Adds &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>&nbsp; label for tooling or protected-file changes, changes spanning multiple modules, unrecognized modules, orphaned modules, or submissions by a module's sole owner
- Adds &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>&nbsp; label when module owners can review
- Adds &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#F4A460;">Status: Module Orphaned 🟡</mark>&nbsp; label for orphaned modules
- Requests eligible individual module owners as reviewers, excluding the author and existing reviewers

**Workflow**: [`platform.set-avm-github-pr-labels.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.set-avm-github-pr-labels.yml) (currently disabled; when enabled, runs when PRs are opened or marked ready for review). Index-based routing does not re-enable the workflow; GitHub App authentication for fork-triggered runs must also be addressed before re-enabling it.

**Source Code**: [`Set-AvmGitHubPrLabels.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/platform/Set-AvmGitHubPrLabels.ps1)

---

### 3. Set-AvmGitHubIssueForWorkflow.ps1

**Purpose**: Creates and manages issues for failed workflow runs.

**Description**: This script monitors workflow run status and automatically creates GitHub issues when module or platform workflows fail. When a workflow fails, it creates an issue with links to the failed run and assigns it to the appropriate module owners. If the workflow subsequently succeeds, the script automatically closes the issue and adds a comment with the successful run link. This ensures prompt notification and tracking of CI/CD pipeline failures.

**Key Functionality**:
- Monitors all GitHub workflow runs in the repository
- Filters out ignored workflows (e.g., PSRule checks, PR title checks)
- Creates new issues for failed workflow runs with detailed information
- Links issues to the specific failed workflow run
- Resolves the affected module from the workflow name, assigns its indexed primary owner, and mentions the resolved individual owners in comments
- Retains the tooling-team fallback for orphaned modules
- Automatically closes issues when workflows succeed after previous failures
- Adds comments to existing issues for repeated failures or successes
- Assigns workflow failure issues to GitHub project boards
- Tracks and reports statistics on issues created, closed, and updated

**Workflow**: [`platform.manage-workflow-issue.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.manage-workflow-issue.yml) (runs daily at 5:30 AM and on-demand)

**Source Code**: [`Set-AvmGitHubIssueForWorkflow.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/platform/Set-AvmGitHubIssueForWorkflow.ps1)

---

### 4. Sync-AvmModulesList.ps1

**Purpose**: Compares the module list in issue templates with CSV data. If not in sync, it creates an issue to update the template.

**Description**: This script ensures that the module list in the GitHub issue template (`avm_module_issue.yml`) remains synchronized with the AVM CSV data. It compares available and orphaned modules from the CSV indexes (Resource, Pattern, and Utility) against the modules listed in the issue template. When discrepancies are detected (missing modules or unexpected modules), the script creates a GitHub issue detailing the necessary changes to bring the template into alignment with the current module inventory.

**Key Functionality**:
- Loads module data from AVM CSV indexes for Resources, Patterns, and Utilities
- Filters for available and orphaned top-level modules
- Parses the GitHub issue template to extract currently listed modules
- Identifies missing modules that should be added to the template
- Identifies unexpected modules that should be removed from the template
- Creates detailed GitHub issues with lists of required changes
- Assigns synchronization issues to the AVM project board
- Ensures issue template stays current as modules are added or deprecated

**Workflow**: [`platform.sync-avm-modules-list.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.sync-avm-modules-list.yml) (runs daily at 4:30 AM and on-demand)

**Source Code**: [`Sync-AvmModulesList.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/platform/Sync-AvmModulesList.ps1)

---

## Summary

The AVM Organizer Bot leverages these automation scripts to maintain repository health, ensure proper module ownership and team configurations, keep documentation current, and provide timely notifications about workflow failures and policy changes. The bot operates continuously through scheduled workflows and event-triggered actions, reducing manual overhead for the AVM core team and module owners while ensuring consistent governance across both repositories.
