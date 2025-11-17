---
title: AVM Organizer Bot
linktitle: AVM Organizer Bot
description: AVM Organizer Bot for the Azure Verified Modules (AVM) program's repositories
---

## Overview

The **AVM Organizer Bot** is represented as a [GitHub App](https://github.com/apps/avm-team-linter) currently named **AVM Team Linter** (which will be renamed to **AVM Organizer** in the future). This bot automates various repository management tasks across the Azure Verified Modules program's repositories, including issue triage, pull request labeling, team validation, and documentation updates.

The bot operates by authenticating with GitHub using the GitHub App credentials (`TEAM_LINTER_APP_ID` and `TEAM_LINTER_PRIVATE_KEY`) and executing PowerShell scripts through scheduled workflows and/or event-triggered actions.

---

## AVM Repository Scripts

The following scripts are leveraged by the **[AVM Organizer Bot](https://github.com/apps/avm-team-linter)** in the [AVM](https://aka.ms/AVM/repo) repository:

### 1. Invoke-AvmGitHubTeamLinter.ps1

**Purpose**: Validates GitHub team configurations against module ownership data from CSV indexes.

**Description**: This script compares the module indexes with existing GitHub Teams configuration to ensure proper team setup. It can validate Bicep parent team configurations, Terraform team permissions, and generate GitHub issues for any discrepancies found. The script supports filtering by module type (Resource/Pattern/Utility) and language (Bicep/Terraform), and can validate `-owner-` teams.

**Key Functionality**:
- Compares module ownership data from CSV files with GitHub team configurations
- Validates parent team configuration for Bicep module owner teams
- Verifies correct repository permissions for Terraform teams
- Creates GitHub issues for unmatched or misconfigured teams
- Closes resolved GitHub issues when team configurations are corrected

**Workflow**: [`github-teams-check-existence.yml`](https://github.com/Azure/Azure-Verified-Modules/blob/main/.github/workflows/github-teams-check-existence.yml) (runs Monday-Friday at 10:00 AM and on-demand)

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

The following scripts are leveraged by the **[AVM Organizer Bot](https://github.com/apps/avm-team-linter)** in the bicep-registry-modules ([BRM](https://aka.ms/BRM)) repository:

### 1. Set-AvmGitHubIssueOwnerConfig.ps1

**Purpose**: Automatically assigns issues to appropriate module owners.

**Description**: This script processes GitHub issues in the BRM repository and automatically assigns them to the correct module owners based on the AVM CSV data. It notifies module owners via comments, assigns the issue to them, adds appropriate labels, and assigns issues to the AVM project board. The script handles both individual issue processing (when triggered by issue creation) and batch processing (when run on schedule).

**Key Functionality**:
- Matches issues to modules based on issue content and labels
- Retrieves module ownership information from AVM CSV indexes (Resource, Pattern, Utility)
- Automatically assigns issues to designated module owners
- Posts notification comments mentioning module owners
- Adds appropriate labels based on module type and status
- Assigns issues to GitHub project boards for tracking
- Handles orphaned modules by assigning to core team
- Tracks statistics on assignments and updates

**Workflow**: [`platform.set-avm-github-issue-owner-config.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.set-avm-github-issue-owner-config.yml) (runs on issue creation, weekly on Sundays at midnight, and on-demand)

**Source Code**: [`Set-AvmGitHubIssueOwnerConfig.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/platform/Set-AvmGitHubIssueOwnerConfig.ps1)

---

### 2. Set-AvmGitHubPrLabels.ps1

**Purpose**: Automatically labels pull requests based on reviewer requirements.

**Description**: This script evaluates newly created or ready-for-review pull requests and adds appropriate labels to indicate whether the PR can be approved by module owners or requires core team review. It analyzes the requested reviewer teams and module ownership data to determine if a module is orphaned or if the sole module owner is the PR author, both scenarios requiring core team intervention.

**Key Functionality**:
- Retrieves PR information including author and requested reviewer teams
- Identifies module-specific reviewer teams (excluding core teams)
- Checks if core team is already assigned as reviewer
- Validates module ownership and team membership
- Adds &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>&nbsp; label when module is orphaned or has insufficient owners
- Adds &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#FF0019;color:white;">Needs: Module Owner 📣</mark>&nbsp; label when module owners can review
- Adds &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#F4A460;">Status: Module Orphaned 🟡</mark>&nbsp; label for orphaned modules
- Automatically adds module team members as reviewers when appropriate

**Workflow**: [`platform.set-avm-github-pr-labels.yml`](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/platform.set-avm-github-pr-labels.yml) (runs when PRs are opened or marked ready for review)

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
- Assigns issues to module owners based on workflow name
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
