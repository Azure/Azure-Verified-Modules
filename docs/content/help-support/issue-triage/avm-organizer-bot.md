---
title: Azure Verified Modules GitHub App
linktitle: Azure Verified Modules GitHub App
description: Azure Verified Modules GitHub App for the Azure Verified Modules (AVM) program's repositories
---

## Overview

The **Azure Verified Modules GitHub App** is represented as a [GitHub App](https://github.com/apps/azure-verified-modules). This app automates various repository management tasks across the Azure Verified Modules program's repositories, including issue triage, pull request labeling, team validation, and documentation updates.

The AVM repository's team linter and AzAdvertizer workflows use the GitHub App credentials (`TEAM_LINTER_APP_ID` and `TEAM_LINTER_PRIVATE_KEY`). Retain these credentials when retiring the team linter: the active AzAdvertizer issue automation also uses them. Bicep repository maintenance workflows run from the AVM tools repository using separately scoped GitHub App tokens.

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

## BRM Repository Automation

The [AVM tools repository](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management) hosts the workflows for [BRM](https://aka.ms/BRM). Owner routing uses the [published module catalog](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/v1/modules.json) and reads a module's root `metadata.json` when the catalog has not yet caught up or the pull request changes that metadata. Child modules inherit root ownership. The CSV indexes show only the first two individual owners and are not the routing source; submit owner changes through the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/).

- [Pull request reviewer routing](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-pr-reviewer-routing.yml) requests the owners of affected modules (excluding the author), applies triage labels, and requests `@Azure/azure-verified-modules-module-owners` for ownerless modules. Review requests and labels do not impose a module-owner approval requirement for ordinary Bicep code changes.
- [Issue owner routing](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-issue-owner-routing.yml) labels module issues by class, mentions their owners, and assigns individual owners while respecting manual assignment decisions. For orphaned modules it mentions the tooling contributors team instead of assigning a module owner.
- [Workflow failure issues](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-workflow-failure-issues.yml) tracks failed module and shared check/publish runs with issues, mentions the owners, assigns the first individual owner when available, and closes tracking issues when the latest completed run no longer reports failure. Orphaned-module and shared-workflow issues mention the tooling contributors team.
- [Module list sync](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-module-list-sync.yml) compares the issue-template dropdown with top-level `Available` and `Orphaned` Bicep entries in the published catalog. When it changes, a verified bot-generated pull request updates the dropdown and is auto-merged rather than opening a drift-report issue.

These workflows support manual dispatch. Their schedules are enabled separately; the presence of a workflow alone does not mean periodic routing is running.

---

## Summary

The AVM repository workflows and the tools-repository workflows support issue triage, reviewer notifications, and module maintenance. Review and merge requirements come from repository rules and the protected metadata [`CODEOWNERS` rule]({{% siteparam base %}}/spec/SNFR20#codeowners-file), not from reviewer requests or triage labels.
