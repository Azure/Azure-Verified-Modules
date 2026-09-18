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

For a new module repository, gather the following approved values from the module request issue. Use this metadata-based creation flow only after the AVM core team verifies and adopts the updated creation tooling and confirms the [metadata rollout prerequisites]({{% siteparam base %}}/contributing/module-metadata/). Repository creation initializes the root `metadata.json` from these explicit inputs; there is no separate CSV registration step.

| Information | Description |
| --- | --- |
| Module name | Format: `avm-<type>-<name>` (e.g. `avm-res-network-virtualnetwork`) |
| Module provider | Optional `moduleProvider`; defaults to `azure` |
| Module display name | Approved display name, passed as `moduleDisplayName` |
| Module description | Required approved description, passed as `moduleDescription` |
| Canonical type | Required approved ARM resource type or pattern/utility taxonomy, passed as `canonicalType`. Resource modules can instead supply both fields in the next row. Do not infer the value from the module name. |
| Resource provider namespace and resource type | For resource modules only, `resourceProviderNamespace` and `resourceType` together are an alternative to `canonicalType` (e.g. `Microsoft.Network` and `virtualNetworks`). They are not required when `canonicalType` is supplied. |
| Telemetry ID prefix | Assigned `telemetryIdPrefix`; required for resource and pattern modules. Do not invent an identifier. |
| Primary and secondary owner handles | Optional `ownerPrimaryGitHubHandle` and `ownerSecondaryGitHubHandle`, using approved bare GitHub usernames |
| Additional owner handles | Optional `ownerGitHubHandles`, a PowerShell string array of approved bare usernames or qualified `@organization/team-slug` entries |
| Owner team | Optional `ownerTeam`, an approved existing team handle in `@organization/team-slug` form |
| Alternative names | Optional `moduleAlternativeNames`, a comma-separated string; the tooling splits it for JSON metadata |

The creation tooling combines all supplied owner handles into the flat root metadata `owners` array, without display-name fields or a two-owner limit. With no handles, `"owners": []` is valid metadata; this does not waive the proposal and ownership processes. These inputs do not grant access. Later ownership changes use the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change), not another repository-creation run.

The [metadata-creation step]({{% siteparam base %}}/contributing/module-metadata/#operator-backfill-and-initialization) creates only `metadata.json` and validates existing metadata without overwriting it. It does not generate `main.metadata.tf` or delete an existing Terraform reader. When using the separate ordinary-sync facility, the surrounding sync can still format, transform, or move Terraform source under its existing rules. For the [reviewed one-off migration]({{% siteparam base %}}/contributing/module-metadata/#reviewed-one-off-terraform-migration), prepare only the reviewed metadata-file changes; do not rerun repository creation or full settings/Azure sync. Source and telemetry integration remain separate work.

## 3. Create the repository

Prerequisites:
- [PowerShell 7.4 or later](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
- [Git](https://git-scm.com/downloads)
- [GitHub CLI](https://cli.github.com)
- Permission to create the repository, push its contents, and edit its custom properties. The script does not grant these rights; confirm access before running it.

### Clone and prepare

Use the [repository creation tooling](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/repository-creation):

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

Supply the approved `canonicalType` below. For a resource module, you can instead replace that entry with both `resourceProviderNamespace` and `resourceType`; pattern and utility modules require an explicit `canonicalType`. Supply the assigned telemetry prefix for resource and pattern modules. For a utility module that does not use telemetry, omit the `telemetryIdPrefix` entry. Do not derive telemetry identifiers from repository names or replace existing identifiers.

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
    telemetryIdPrefix = "<assigned telemetry ID prefix>"
    ownerPrimaryGitHubHandle = "<approved individual handle>"
}

.\scripts\New-Repository.ps1 @parameters -planOnly
```

Add optional entries to `$parameters` when needed, using the parameter names in the table above. Keep `ownerGitHubHandles` as an array, such as `@("additional-owner", "@Azure/approved-team")`, and `moduleAlternativeNames` as a comma-separated string; do not pass a new `owners` parameter.

`-planOnly` and `-WhatIf` validate the inputs and show the plan without making GitHub or filesystem changes. Review the plan, then run the same command without either switch to create the repository.

| Other option | Purpose |
| --- | --- |
| `-tempPath` | Optional location for temporary staging |
| `-skipCreateAppInstallationRequest` | Skip the GitHub App installation request |
| `-skipRepoCreation` | Request the GitHub App installation for an existing repository only; does not create or update metadata |

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

The script will automatically:
- Initialize and validate the root `metadata.json` from the creation inputs and publish it in the first commit to `main`.
- Create the `Azure Verified Modules` GitHub App installation request, unless skipped.

{{% notice style="note" %}}
The root file is the repository's metadata source; there is no registration change in the retired tools-local inventory CSV. Maintain the module's details and full `owners` array through [metadata code-owner review]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change). This does not change the Open Source Portal, access-package, or JIT requirements below, or remove the generated public module-index CSVs.
{{% /notice %}}

### Initial commit and recovery

Only after successfully creating a **new empty repository**, the script records the prior `rulesets-default-opt-in` custom-property value in `ruleset-recovery.json` in its isolated staging directory. The record preserves the original string value or `null` for an unset property. If it is not already `"false"`, the script temporarily sets it to `"false"` and verifies the API readback before pushing the prepared first commit to `main`.

If this run attempted to change the property, the script restores the original value in `finally` and verifies the readback on success or failure, including an ambiguous failed opt-out request. Restoring `null` resets an originally unset property. If the property was already `"false"`, it is left unchanged. This changes only the new repository's opt-in to the organization default ruleset; it does not change global opt-out settings, production classification, organization rulesets, or protections on established repositories.

API or readback errors stop the operation. On failure, staging and any available recovery data are retained, and the script reports whether the first commit was pushed. A restoration failure needs operator attention **before retrying**. Abrupt process termination can prevent `finally` from running: inspect the recovery record and the live property rather than assuming protection was restored. Creation errors do not automatically delete repositories or force-push. Planning modes perform none of these actions.

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

Sync reads the root `metadata.json` from the module repository's default branch for `moduleDisplayName` and the full `owners` list. GitHub's `archived` flag is authoritative; metadata has no `isArchived` field. See [repository metadata discovery]({{% siteparam base %}}/contributing/module-metadata/#terraform-repository-sync) for rollout and error handling.
