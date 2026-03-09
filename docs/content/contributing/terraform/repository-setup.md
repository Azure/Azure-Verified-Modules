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
3. Navigate to [Core Identity](https://coreidentity.microsoft.com/manage/Entitlement/entitlement/azureverifie-ks5z) and request access to the `Azure Verified Module Owners Terraform` entitlement.

{{% notice style="info" %}}
Until your entitlement request is approved, you can contribute by using JIT elevation.
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
$moduleProvider = "azurerm" # Allowed: azurerm, azapi, azure
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
    -moduleProvider $moduleProvider `
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
| Direct owners | Add yourself and `jaredholgate` or `mawhi`. Add `avm-team-module-owners` as fallback security group. |
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
    - **Direct owners:** Add yourself and `jaredholgate` or `mawhi`. Add `avm-team-module-owners` as fallback.
    - **Classify the repository:** Production
    - **Service tree:** Azure Verified Modules / AVM
2. Go back to **Overview** and click **Elevate your access** if available.

{{% /expand %}}

Return to the terminal and type `yes` to complete repository configuration.

The script will automatically:
- Create a PR to add module metadata to the `avm-terraform-governance` repository.
- Create an issue to install the `Azure Verified Modules` GitHub App.

## 4. Update the issue status

1. Add the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#27AB03;color:white;">Status: Repository Created 📄</mark>&nbsp; label.
2. Remove the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#136A41;color:white;">Status: Ready For Repository Creation 📝</mark>&nbsp; label if present.

## 5. Wait for the GitHub App

Once installed (usually within 24 hours), the environment sync runs automatically at 15:30 UTC on weekdays to complete the repository setup.
