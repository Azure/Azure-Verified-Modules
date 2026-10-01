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

Gather the following approved values from the module request issue. `avm init` writes them to the root `metadata.json` in the repository's first commit.

| Information | Description |
| --- | --- |
| Repository name | `terraform-azure-avm-<type>-<name>`, built from the approved module name `avm-<type>-<name>` (e.g. `avm-res-network-virtualnetwork` becomes `terraform-azure-avm-res-network-virtualnetwork`). It is also the name of your local folder. |
| Module type | `resource`, `pattern`, or `utility`, matching `res`, `ptn`, or `utl` in the module name. |
| Module display name | Approved display name, supplied as `moduleDisplayName` |
| Module description | Approved description, supplied as `moduleDescription` |
| Canonical type | Approved ARM resource type (e.g. `Microsoft.Network/virtualNetworks`) or pattern/utility taxonomy, supplied as `canonicalType`. Do not infer the value from the module name. |
| Owners | `owners`, a PowerShell string array of approved bare GitHub usernames or qualified `@organization/team-slug` entries |
| Telemetry ID prefix | Optional `telemetryIdPrefix`. Supply the assigned identifier if the proposal has one. If you omit it, `avm init` mints one in the fleet format `46d3xtrf.<res\|ptn>.<7 lowercase hex characters>` for resource and pattern modules. Never hand-pick an identifier yourself. Utility modules do not use telemetry. |
| Alternative names | Optional `alternativeNames`, a PowerShell string array |

Record every approved owner. An empty owner array is valid for an unowned module, subject to the proposal and ownership processes. Metadata does not grant access. Later ownership changes use the [metadata review process]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change).

## 3. Create the repository

Prerequisites:

- [PowerShell 7.4 or later](https://learn.microsoft.com/powershell/scripting/install/installing-powershell)
- [Git](https://git-scm.com/downloads)
- [GitHub CLI](https://cli.github.com)
- The latest [`Avm.Authoring`](https://www.powershellgallery.com/packages/Avm.Authoring) module, installed as described in the [Terraform prerequisites]({{% siteparam base %}}/contributing/terraform/prerequisites/#required-tooling). Run `avm update` to upgrade an existing installation.
- AVM core team approval to create the repository.
- A configured Git commit identity (`git config --global user.name` and `git config --global user.email`).

### Authenticate

```pwsh
gh auth login --hostname "github.com" --web --git-protocol "https" --scopes "workflow"
```

`avm init` needs the `repo`, `read:org`, and `workflow` scopes, and `gh auth login` requests the first two by default. If you are already signed in, run `gh auth refresh --hostname "github.com" --scopes "workflow"` instead. If you set `GH_TOKEN`, that token needs the same scopes.

### Run avm init

Run these commands from the folder that should contain the repository's local folder. Replace the placeholders with the approved values.

```pwsh
$metadata = @{
    moduleDisplayName = "<approved display name>"
    moduleDescription = "<approved description>"
    canonicalType = "<approved ARM resource type or taxonomy>"
    owners = @("<approved individual handle>")
}

avm init -Ecosystem terraform -ModuleType resource -Path "./<repository name>" -InputObject $metadata -WhatIf
```

Use `-ModuleType pattern` or `-ModuleType utility` for pattern and utility modules. Add `telemetryIdPrefix` or `alternativeNames` to `$metadata` when needed. In an interactive terminal, you can omit `-InputObject` and enter the values when `avm init` prompts for them.

`-WhatIf` validates the values and lists the stages without making GitHub or filesystem changes. Review the output and obtain the required approval, then run the same command without `-WhatIf`. `avm init` then:

1. Writes `metadata.json` to the folder. Later runs read the values from this file, so you only supply them once.
1. Creates the public repository in the `Azure` organization.
1. Pauses while you complete the Open Source Portal setup below and elevate with JIT.
1. Grants the `azure-verified-modules-module-contributors` team push access and the `azure-verified-modules-module-readers` team triage access.
1. Publishes the first commit to `main`: `metadata.json`, a minimal module scaffold, and the managed files, telemetry, and README added by `avm pre-commit`. `_header.md` starts with the module's display name and description.
1. Opens a pull request in `microsoft/github-operations` from your fork, requesting the `Azure Verified Modules` and Terraform Cloud GitHub App installations, and prints its link.
1. Clones the repository into the folder.
1. Reminds you to tie the repository to the shared AVM JIT rule in [step 4](#4-tie-the-repository-to-the-shared-avm-jit-rule). `avm init` cannot check this portal setting, so it lists the step as `manual` every time it completes.

If a stage fails, or you stop the command, fix the reported problem and run the same command again on the same machine. Each stage checks what already exists, so `avm init` continues where it stopped.

### Complete Open Source Portal Setup

`avm init` pauses after creating the repository and prints the Open Source Portal link and these answers.

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
1. Go back to **Overview** and click **Elevate your access** if available.

{{% /expand %}}

Return to the terminal and type `yes` to continue. If `avm init` asks you to elevate again later, click **Elevate your access** on the repository overview, then type `yes`.

{{% notice style="note" %}}
Maintain the module's details and full `owners` array through [metadata code-owner review]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change). Complete the Open Source Portal, access-package, and JIT requirements separately.
{{% /notice %}}

## 4. Tie the repository to the shared AVM JIT rule

New repositories default to **JIT v1**. AVM repositories must use **JIT v2** and be tied to the shared `service-AVM-azure-verified-modules-module-owners` rule, so that just-in-time elevation is governed centrally by the AVM team rather than by a repository-specific rule. Proposing the tie also upgrades the repository to JIT v2.

This is a one-off manual action in the Open Source Portal. Do it after `avm init` has published the first commit, because it changes how you elevate. You need Direct Owner access to the repository, configured in the previous step. If you do not have permission to propose the tie, skip this step and email [avm@microsoft.com](mailto:avm@microsoft.com) with the repository name so the AVM core team can complete it.

1. Open the repository overview on the Open Source Portal: `https://repos.opensource.microsoft.com/orgs/Azure/repos/<repository name>`.
1. Click **Advanced JIT options**, then select **Propose a new tie**.
1. Under **Propose tying a new rule to this repository**, enter the Rule ID `service-AVM-azure-verified-modules-module-owners` and click **Review**.
1. Confirm the details and click **Create tie**.

The result page shows whether the tie is active or waiting for approval. On a repository still using JIT v1, a tie proposed by a Direct Owner can become active immediately. Once it is active, the repository overview shows **JIT version: JIT v2** and the shared rule.

{{% notice style="info" %}}
A pending tie must be approved by an owner of the `service-AVM-azure-verified-modules-module-owners` rule (an AVM core team member). Ask the AVM core team to approve it. Once approved, just-in-time elevation for the repository is governed by the shared AVM rule.
{{% /notice %}}

### Remove yourself as a Direct Owner

You were added as a Direct Owner so you could configure JIT. Once you have proposed the tie, or emailed the AVM core team, remove your own account so that only `jaredholgate` and `jatracey` remain as Direct Owners.

1. On the Open Source Portal, open the repository's **Compliance** tab.
1. Under **Direct owners**, remove your own account, leaving only `jaredholgate` and `jatracey`.

{{% notice style="info" %}}
Module owners retain day-to-day access through the `azure-verified-modules-module-owners` security group and just-in-time elevation, so you do not need to remain a Direct Owner.
{{% /notice %}}

## 5. Wait for the GitHub App and repository sync

The GitHub Apps are installed once the app installation pull request is approved. Running `avm init` again shows whether the request is still pending.

After the app is installed, [repository sync](https://github.com/Azure/azure-verified-modules-tools/tree/main/repository-management/repository-sync) applies the shared repository configuration and [managed files](https://github.com/Azure/azure-verified-modules-managed-files) to complete the setup.

Sync reads the root `metadata.json` from the module repository's default branch for the display name and full owner list.
