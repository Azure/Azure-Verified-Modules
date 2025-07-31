---
title: Terraform Core Team Repository Creation Process
linktitle: Repository Creation Process
description: Terraform Core Team Repository Creation Process for the Azure Verified Modules (AVM) program
---

This section describes the process for AVM owners who are responsible for creating their Terraform Module repositories.

{{% notice style="important" %}}

If this process is not followed exactly, it may result in your repository and any in progress code being permanently deleted. Please ensure you follow the steps exactly as described below.

{{% /notice %}}

### 1. Add yourself to the Module Owners Team

If you have already done this, then you don't need to do it again and can skip this section.

1. Open the [Open Source Portal](https://repos.opensource.microsoft.com/link) and ensure you GitHub account is linked to your Microsoft account
1. Open the [Open Source Portal](https://repos.opensource.microsoft.com/orgs) and ensure you are a member of the `Azure` organization
1. Navigate to [Core Identity](https://coreidentity.microsoft.com/manage/Entitlement/entitlement/azureverifie-ks5z) and request access to the `Azure Verified Module Owners Terraform` entitlement

{{% notice style="info" %}}

Please note that until your request is approved to join the `Azure Verified Module Owners Terraform` entitlement, you will only be able to contribute to your new repository if you JIT elevate first.

{{% /notice %}}

### 2. Get the information you need for Repository Creation

You'll need to gather the following information from the module request issue and other sources:

1. Module name: This will be in the format `avm-<type>-<name>`. e.g. `avm-res-network-virtualnetwork`
1. Module owner GitHub handle: This is your own GitHub handle
1. Module owner display name: This is your name in the format `Firstname Lastname`. This is used to display the module owner in the module index CSV file
1. Module description: The description will automatically be prefixed with `Terraform Azure Verified <module-type> Module for ...`, where `<module-type>` is either Resource, Pattern, or Utility
1. Resource provider namespace: This is only required for resource modules. You may need to look this up in the Azure Documentation if not included in the issue. For example, `Microsoft.Network` for a Virtual Network module
1. Resource type: This is only required for resource modules. You may need to look this up in the Azure Documentation if not included in the issue. For example, `virtualNetworks` for a Virtual Network module
1. Module alternative names: Consider if it would be useful to search for this module using other names. If so, add them here. This is a comma separated list of names
1. Owner secondary GitHub handle: This is optional. If the module has a secondary owner GitHub handle
1. Owner secondary display name: This is optional. If the module has a secondary owner, get their display name in the format `Firstname Lastname`. This is used to display the module owner in the module index CSV file

### 3. Create the repository

1. Open a PowerShell terminal
1. Clone the <https://github.com/Azure/avm-terraform-governance> repository and navigate to the `tf-repo-mgmt` folder

    ```pwsh
    git clone "https://github.com/Azure/avm-terraform-governance"
    cd ./tf-repo-mgmt
    ```

1. Install the GitHub CLI if you don't already have it installed: <https://cli.github.com>
1. Login to GitHub CLI

    ```pwsh
    gh auth login -h "github.com" -w -p "https" -s "delete_repo" -s "workflow" -s "read:user" -s "user:email"
    ```

    Follow the prompts to login to your GitHub account.

1. Run the following command, replacing the values with the details you collected in step 2

    ```pwsh
    # Required Inputs
    $moduleProvider = "azurerm" # Only change this if you know why you need to change it (Allowed values: azurerm, azapi, azure)
    $moduleName = "<module name>" # Replace with the module name (do not include the "terraform-azurerm" prefix)
    $moduleDisplayName = "<module description>" # Replace with a short description of the module
    $resourceProviderNamespace = "" # Replace with the resource provider namespace of the module (NOTE: Leave empty for Pattern or Utility Modules)
    $resourceType = "" # Replace with the resource type of the module (NOTE: Leave empty for Pattern or Utility Modules)
    $ownerPrimaryGitHubHandle = "<github user handle>" # Replace with the GitHub handle of the module owner
    $ownerPrimaryDisplayName = "<user display name>" # Replace with the display name of the module owner

    # Optional Metadata Inputs
    $moduleAlternativeNames = "" # Replace with a comma separated list of alternative names for the module
    $ownerSecondaryGitHubHandle = "" # Replace with the GitHub handle of the module owner
    $ownerSecondaryDisplayName = "" # Replace with the display name of the module owner

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

    For example:

    ```pwsh
    # Required Inputs
    $moduleProvider = "azurerm" # Only change this if you know why you need to change it (Allowed values: azurerm, azapi, azure)
    $moduleName = "avm-res-network-virtualnetwork" # Replace with the module name (do not include the "terraform-azurerm" prefix)
    $moduleDisplayName = "Virtual Networks" # Replace with a short description of the module
    $resourceProviderNamespace = "Microsoft.Network" # Replace with the resource provider namespace of the module (NOTE: Leave empty for Pattern or Utility Modules)
    $resourceType = "virtualNetworks" # Replace with the resource type of the module (NOTE: Leave empty for Pattern or Utility Modules)
    $ownerPrimaryGitHubHandle = "jaredfholgate" # Replace with the GitHub handle of the module owner
    $ownerPrimaryDisplayName = "Jared Holgate" # Replace with the display name of the module owner

    # Optional Metadata Inputs
    $moduleAlternativeNames = "VNet" # Replace with a comma separated list of alternative names for the module
    $ownerSecondaryGitHubHandle = "" # Replace with the GitHub handle of the module owner
    $ownerSecondaryDisplayName = "" # Replace with the display name of the module owner

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

1. The script will stop and prompt you to fill out the Microsoft Open Source details.
1. Open the Open Source Portal using the link in the script output.
1. Click `Complete Setup`, then use the following table to provide the settings:

    | Question | Answer |
    | --- | --- |
    | Classify the repository | Production |
    | Assign a Service tree or Opt-out | Azure Verified Modules / AVM |
    | Direct owners | Add the module owner and yourself as direct owners. Add the avm-team-module-owners as security group. |
    | Is this going to ship as a public open source licensed project | Yes, creating an open source licensed project |
    | What type of open source will this be | Sample code |
    | What license will you be releasing with | MIT |
    | Did your team write all the code and create all of the assets you are releasing? | Yes, all created by my team |
    | Does this project send any data or telemetry back to Microsoft? | Yes, telemetry |
    | Does this project implement cryptography | No |
    | Project name | Azure Verified Module (Terraform) for '*module name*' |
    | Project version | 1 |
    | Project description | Azure Verified Module (Terraform) for '*module name*'. Part of AVM project - <https://aka.ms/avm> |
    | Business goals | Create IaC module that will accelerate deployment on Azure using Microsoft best practice. |
    | Will this be used in a Microsoft product or service? | This is open source project and can be leveraged in Microsoft service and product. |
    | Adopt security best practice? | Yes, use just-in-time elevation |
    | Maintainer permissions | Leave empty |
    | Write permissions | Leave empty |
    | Repository template | Uncheck |
    | Add .gitignore | Uncheck |

1. Click `Finish setup + start business review` to complete the setup
1. Wait for it to process and then click `View repository`
1. If you don't see the `Elevate your access` button, then refresh the browser window
1. Click `Elevate your access` and follow the prompts to elevate your access
1. Now head back over to the terminal and type `yes` and hit enter to complete the repository configuration
1. Open the new repository in GitHub.com and verify it all looks good.
1. The script will automatically create a pull request to add the module metadata to the `avm-terraform-governance` repository. This will be approved and merged by the core team. You can find it [here](https://github.com/Azure/avm-terraform-governance/pulls) if you lost the link.
1. The script will automatically create an issue to install the `Azure Verified Modules` GitHub App in the repository. This will be actioned by the open source team. You can find it [here](https://gihub.com/microsoft/github-operations/issues) if you lost the link.

### 4. Update the Issue Status

1. Add the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#27AB03;color:white;">Status: Repository Created 📄</mark>&nbsp; label to the issue
1. Remove the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#136A41;color:white;">Status: Ready For Repository Creation 📝</mark>&nbsp; label from the issue if it was added

### 5. Wait for the GitHub App to be installed

Once the GitHub App has been installed via the issue raised by the script, the sync to create the environment and credentials will be triggered automatically at 15:30 UTC on week days. This will complete the repository creation process.

The open source team will usually complete this within 24 hours, but it can take longer in some cases.
