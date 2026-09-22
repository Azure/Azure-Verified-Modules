---
title: Repository Creation Process
linktitle: Repository Setup
description: Process for AVM module owners to create new Terraform module repositories
weight: 6
---

{{% notice style="important" %}}
This page is for **module owners only**. If you are an external contributor, skip to the [contribution flow]({{% siteparam base %}}/contributing/terraform/contribution-flow/).
{{% /notice %}}

{{% notice style="important" %}}
Every repository created through this process **MUST** use AzAPI for every control-plane resource and supported data-plane operation. AzureRM is permitted only for a specific unsupported data-plane/non-ARM API operation under the narrow [TFFR3]({{% siteparam base %}}/spec/TFFR3) exception. The exception must be documented and applies only to that operation in the root module, submodules, examples, end-to-end tests, Terraform tests, fixtures, and documentation snippets.
{{% /notice %}}

{{% notice style="important" %}}
If this process is not followed exactly, it may result in your repository and any in-progress code being permanently deleted.
{{% /notice %}}

## 1. Add yourself to the Module Owners Team and Open Source orgs

If you have already completed these steps, skip to step 2.

1. Open the [Open Source Portal](https://repos.opensource.microsoft.com/link) and ensure your GitHub account is linked to your Microsoft account.
2. Open the [Open Source Portal](https://repos.opensource.microsoft.com/orgs) and ensure you are a member of the `Azure` and `Microsoft` organizations.
3. Request access via the [Azure Verified Modules (AVM) Module Contributors access package](https://aka.ms/avm/id/access-package/module-contributor). Approval adds you to the [`azure-verified-modules-module-contributors`](https://aka.ms/avm/id/groups/module-contributors) Entra group.

{{% notice style="info" %}}
Until your access request is approved, you can contribute by using JIT elevation.
{{% /notice %}}

## 2. Gather repository information

Gather the following approved values from the module request issue. Repository creation uses them to initialize the root `metadata.json`.

| Information | Description |
| --- | --- |
| Module name | Format: `avm-<type>-<name>` (e.g. `avm-res-network-virtualnetwork`) |
| Module provider | Optional `moduleProvider`; defaults to `azure` |
| Module display name | Approved display name, passed as `moduleDisplayName` |
| Module description | Required approved description, passed as `moduleDescription` |
| Canonical type | Required approved ARM resource type or pattern/utility taxonomy, passed as `canonicalType`. Resource modules can instead supply both fields in the next row. Do not infer the value from the module name. |
| Resource provider namespace and resource type | For resource modules only, `resourceProviderNamespace` and `resourceType` together are an alternative to `canonicalType` (e.g. `Microsoft.Network` and `virtualNetworks`). They are not required when `canonicalType` is supplied. |
| Telemetry ID prefix | Optional `telemetryIdPrefix`. Supply the assigned identifier if the proposal has one. If you omit it, creation mints one in the fleet format `46d3xtrf.<res\|ptn>.<7 lowercase hex characters>` for resource and pattern modules. Never hand-pick an identifier yourself. |
| Owners | `ownerGitHubHandles`, a PowerShell string array of approved bare usernames or qualified `@organization/team-slug` entries. `ownerTeam` adds an approved owning team, and the legacy `ownerPrimaryGitHubHandle` and `ownerSecondaryGitHubHandle` parameters are still accepted. |
| Alternative names | Optional `moduleAlternativeNames`, a comma-separated string; the tooling splits it for JSON metadata |

Record every approved owner. An empty owner array is valid for an unowned module, subject to the proposal and ownership processes. Metadata does not grant access. Later ownership changes use the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change).

## 3. Create the repository

Prerequisites:
- [PowerShell 7.4 or later](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
- [Git](https://git-scm.com/downloads)
- [GitHub CLI](https://cli.github.com)
- AVM core team approval and permission to create the repository, push its contents, and edit its custom properties.
- A configured Git commit identity.

### Clone and prepare

Use a trusted checkout of the [repository creation tooling](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/repository-creation). Its README covers operator prerequisites, additional options, and recovery.

```pwsh
Set-Location $HOME
git clone "https://github.com/Azure/azure-verified-modules-tools"
Set-Location .\azure-verified-modules-tools\repository-management\repository-creation
```

### Authenticate

```pwsh
gh auth login -h "github.com" -w -p "https"
```

### Run the creation script

Supply the approved `canonicalType` below. For a resource module, you can instead replace that entry with both `resourceProviderNamespace` and `resourceType`; pattern and utility modules require an explicit `canonicalType`. Supply the assigned telemetry prefix if the proposal has one; otherwise omit `telemetryIdPrefix` and let creation mint it for resource and pattern modules. Utility modules do not use telemetry. Do not derive telemetry identifiers from repository names or replace existing identifiers.

```pwsh
if (!(Test-Path -Path ".\scripts\New-Repository.ps1")) {
    Write-Error "This script must be run from the repository-creation directory."
    exit 1
}

$parameters = @{
    moduleName = "<approved module name>"
    moduleDisplayName = "<approved display name>"
    moduleDescription = "<approved description>"
    canonicalType = "<approved ARM resource type or taxonomy>"
    ownerGitHubHandles = @("<approved individual handle>")
}

.\scripts\New-Repository.ps1 @parameters -planOnly
```

Add optional entries from the table when needed, including `telemetryIdPrefix` when the proposal already assigns one. Keep `ownerGitHubHandles` as an array, such as `@("first-owner", "@Azure/approved-team")`, and `moduleAlternativeNames` as a comma-separated string.

`-planOnly` and `-WhatIf` validate the inputs and show the plan without making GitHub or filesystem changes. Review the plan, including any minted telemetry identifier, and obtain the required approval before running the same command without either switch.

Creation publishes validated root metadata in the first commit to `main`. If creation fails, stop and follow the recovery guidance in the tooling README before retrying.

### Complete Open Source Portal Setup

The script will pause and prompt you to configure the Open Source Portal. Follow the link in the script output.

{{% expand title="➕ If you see the Complete Setup link" %}}

Click **Complete Setup** and use the following settings:

| Question | Answer |
| --- | --- |
| Classify the repository | Production |
| Assign a Service tree or Opt-out | Azure Verified Modules / AVM |
| Direct owners | Add yourself, `jaredholgate`, and `jatracey`. Add `azure-verified-modules-module-owners` as fallback security group. You add yourself temporarily so you can configure JIT in step 4; you will remove yourself afterwards. |
| Public open source licensed project? | Yes |
| What type of open source? | Sample code |
| License | MIT |
| All code created by your team? | Yes |
| Telemetry? | Yes, telemetry |
| Cryptography? | No |
| Project name | Azure Verified Module (Terraform) for '*module name*' |
| Project version | 1 |
| Project description | Azure Verified Module (Terraform) for '*module name*'. Part of AVM project - <https://aka.ms/avm> |
| Business goals | Create IaC module accelerating Azure deployment using Microsoft best practice. |
| Used in a Microsoft product? | Open source, can be leveraged in Microsoft services. |
| Security best practice? | Yes, use just-in-time elevation |
| Maintainer / Write permissions | Leave empty |
| Repository template / .gitignore | Uncheck both |

Click **Finish setup + start business review**, then **View repository**, then **Elevate your access**.

{{% /expand %}}

{{% expand title="➕ If you do NOT see the Complete Setup link" %}}

1. Go to the **Compliance** tab and fill out:
    - **Direct owners:** Add yourself, `jaredholgate`, and `jatracey`. Add `azure-verified-modules-module-owners` as fallback. You add yourself temporarily so you can configure JIT in step 4; you will remove yourself afterwards.
    - **Classify the repository:** Production
    - **Service tree:** Azure Verified Modules / AVM
2. Go back to **Overview** and click **Elevate your access** if available.

{{% /expand %}}

Return to the terminal and type `yes` to complete repository configuration.

The script creates the `Azure Verified Modules` GitHub App installation request.

{{% notice style="note" %}}
Maintain the module's details and full `owners` array through [metadata code-owner review]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change). Complete the Open Source Portal, access-package, and JIT requirements separately.
{{% /notice %}}

## 4. Upgrade just-in-time access to JITv2

New repositories default to **JIT v1**. AVM repositories must be upgraded to **JIT v2** and tied to the shared `service-AVM-azure-verified-modules-module-owners` rule, so that just-in-time elevation is governed centrally by the AVM team rather than by a repository-specific rule.

This is a one-off manual action in the Open Source Portal. You need Direct Owner access to the repository (configured in the previous step) to complete it.

### Migrate the repository to JIT v2

1. Open the repository overview on the Open Source Portal: `https://repos.opensource.microsoft.com/orgs/Azure/repos/<module name>`.
2. In the right-hand sidebar, find the **Improved Just-in-time** (`New`) panel and click **Next**.
3. Review the concepts (Rule Version, Rule, Tie) and click **Next**.
4. Leave **Require approval for elevation** selected and click **Upgrade `<module name>` now**.

This migrates the repository to JIT v2 and creates a temporary repository-scoped starter rule. Reload the page and confirm the **Just-in-time elevation** section now shows **JIT version: JIT v2**.

### Tie the repository to the shared AVM rule

1. On the repository overview, click **Advanced JIT options**, then select **Propose a new tie**.
2. Under **Propose tying a new rule to this repository**, enter the Rule ID `service-AVM-azure-verified-modules-module-owners` and click **Review**.
3. Confirm the details and click **Create tie**.

The tie is created in a **pending approval** state, so the temporary repository-scoped rule stays active until the tie is approved.

{{% notice style="info" %}}
The pending tie must be approved by an owner of the `service-AVM-azure-verified-modules-module-owners` rule (an AVM core team member). Ask the AVM core team to approve it. Once approved, just-in-time elevation for the repository is governed by the shared AVM rule and the temporary starter rule can be ignored.
{{% /notice %}}

### Remove yourself as a Direct Owner

You were added as a Direct Owner so you could perform the JIT configuration above. Once you have finished both the JIT v2 upgrade and the shared-rule tie, remove your own account so that only `jaredholgate` and `jatracey` remain as Direct Owners.

1. On the Open Source Portal, open the repository's **Compliance** tab.
2. Under **Direct owners**, remove your own account, leaving only `jaredholgate` and `jatracey`.

{{% notice style="info" %}}
Module owners retain day-to-day access through the `azure-verified-modules-module-owners` security group and just-in-time elevation, so you do not need to remain a Direct Owner.
{{% /notice %}}

## 5. Wait for the GitHub App and repository sync

After the app is installed, [repository sync](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/repository-sync) applies the shared repository configuration and [managed files](https://github.com/Azure/azure-verified-modules-managed-files) to complete the setup.

Sync reads the root `metadata.json` from the module repository's default branch for the display name and full owner list.
