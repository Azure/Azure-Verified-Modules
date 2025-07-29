---
title: Terraform Core Team Repository Creation Process
linktitle: Repository Creation Process
description: Terraform Core Team Repository Creation Process for the Azure Verified Modules (AVM) program
---

### 2. Create the repository

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

1. Run the following command, replacing the values with the details you collected in step 1

    ```pwsh
    # Required Inputs
    $moduleProvider = "azurerm" # Only change this if you know why you need to change it (Allowed values: azurerm, azapi, azure)
    $moduleName = "<module name>" # Replace with the module name (do not include the "terraform-azurerm" prefix)
    $moduleDisplayName = "<module description>" # Replace with a short description of the module
    $resourceProviderNamespace = "<resource provider namespace>" # Replace with the resource provider namespace of the module (NOTE: Leave empty for Pattern or Utility Modules)
    $resourceType = "<resource type>" # Replace with the resource type of the module (NOTE: Leave empty for Pattern or Utility Modules)
    $ownerPrimaryGitHubHandle = "<github user handle>" # Replace with the GitHub handle of the module owner
    $ownerPrimaryDisplayName = "<user display name>" # Replace with the display name of the module owner

    # Optional Metadata Inputs
    $moduleAlternativeNames = "<alternative names>" # Replace with a comma separated list of alternative names for the module
    $ownerSecondaryGitHubHandle = "<github user handle>" # Replace with the GitHub handle of the module owner
    $ownerSecondaryDisplayName = "<user display name>" # Replace with the display name of the module owner

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
    1. On the home page
        1. The name is correct
        1. The description is correct
        1. The Terraform registry url looks good
        1. The repository has the template files in it
    1. In Setting
        1. The repository is public
        1. The Collaborators and teams are correct

### 3. GitHub App Install

The script will automatically create an issue to get the Azure Verified modules GitHub app installed,
It will output the issue URL.
You should monitor the status of this issue as it is requried for the AVM team to be able to manage your repo.
The sync to create the test environment details and credentials will be triggered automatically at 15:30 UTC on week days.
If you do not see the test environment on your repo within two business days, then reach out to the AVM team.
