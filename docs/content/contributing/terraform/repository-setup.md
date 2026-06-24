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

You'll need the following from the module request issue:

| Information | Description |
| --- | --- |
| Module name | Format: `avm-<type>-<name>` (e.g. `avm-res-network-virtualnetwork`) |
| Module owner GitHub handle | Your GitHub handle |
| Module owner display name | `Firstname Lastname` |
| Module description | Auto-prefixed with `Terraform Azure Verified <module-type> Module for ...` |
| Resource provider namespace | Resource modules only (e.g. `Microsoft.Network`) |
| Resource type | Resource modules only (e.g. `virtualNetworks`) |
| Alternative names | Optional comma-separated list |
| Secondary owner handle | Optional |
| Secondary owner display name | Optional |

## 3. Create the repository

Prerequisites:
- Latest [Terraform CLI](https://developer.hashicorp.com/terraform/install)
- Latest [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli)
- Latest [PowerShell Core](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
- [GitHub CLI](https://cli.github.com)

### Clone and prepare

```pwsh
cd ~
git clone "https://github.com/Azure/avm-terraform-governance"
cd ./avm-terraform-governance/tf-repo-mgmt
```

### Authenticate

```pwsh
# GitHub CLI
gh auth login -h "github.com" -w -p "https" -s "delete_repo" -s "workflow" -s "read:user" -s "user:email"

# Azure CLI (if not already logged in)
az login --scope https://graph.microsoft.com/.default --allow-no-subscriptions
```

### Run the creation script

```pwsh
if(!(Test-Path -Path "./scripts/New-Repository.ps1")) {
    Write-Error "This script must be run from the tf-repo-mgmt directory."
    exit 1
}

# Required Inputs
$moduleName = "<module name>" # e.g. avm-res-network-virtualnetwork
$moduleDisplayName = "<module description>"
$resourceProviderNamespace = "" # Leave empty for Pattern/Utility modules
$resourceType = "" # Leave empty for Pattern/Utility modules
$ownerPrimaryGitHubHandle = "<github handle>"
$ownerPrimaryDisplayName = "<display name>"

# Optional
$moduleAlternativeNames = ""
$ownerSecondaryGitHubHandle = ""
$ownerSecondaryDisplayName = ""

./scripts/New-Repository.ps1 `
    -moduleName $moduleName `
    -moduleDisplayName $moduleDisplayName `
    -resourceProviderNamespace $resourceProviderNamespace `
    -resourceType $resourceType `
    -ownerPrimaryGitHubHandle $ownerPrimaryGitHubHandle `
    -ownerPrimaryDisplayName $ownerPrimaryDisplayName `
    -moduleAlternativeNames $moduleAlternativeNames `
    -ownerSecondaryGitHubHandle $ownerSecondaryGitHubHandle `
    -ownerSecondaryDisplayName $ownerSecondaryDisplayName
```

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
- Create a PR to add module metadata to the `avm-terraform-governance` repository.
- Create an issue to install the `Azure Verified Modules` GitHub App.

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

## 5. Wait for the GitHub App

Once installed (usually within 24 hours), the environment sync runs automatically at 15:30 UTC on weekdays to complete the repository setup.
