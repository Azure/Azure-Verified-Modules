---
title: Terraform Core Team Repository Creation Process
linktitle: Repository Creation Process
description: Terraform Core Team Repository Creation Process for the Azure Verified Modules (AVM) program
---

This section describes the process for AVM core team members who are responsible for creating Terraform Module repositories.

{{% notice style="important" %}}

This contribution flow is for **AVM Core Team members** only.

{{% /notice %}}

### 1. Find Issues Ready for Repository Creation

1. When a module owner is ready to start development, they will add the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#136A41;color:white;">Status: Ready For Repository Creation 📝</mark>&nbsp; label to the proposal via a comment [issue](https://github.com/Azure/Azure-Verified-Modules/issues).
1. To find issues that are ready for repository creation, click this [link](https://github.com/Azure/Azure-Verified-Modules/labels/Status%3A%20Ready%20For%20Repository%20Creation%20%3Amemo%3A)
1. Open one of the issues to find the details you need.
    1. Module name: This will be in the format `avm-<type>-<name>`. e.g. `avm-res-network-virtualnetwork`
    1. Module owner GitHub handle: This will be in the content of the issue
    1. Module owner display name: You may need to look this up in the open source portal
    1. Module description: If this does not exist, then create one. The description will automtically be prefixed with `Terraform Azure Verified <module-type> Module for ...`, where `<module-type>` is either Resource, Pattern, or Utility
    1. Resource provider namespace: You may need to look this up if not included in the issue
    1. Resource type: You may need to look this up if not included in the issue
    1. Module alternative names: Consider if it would be useful to search for this module using other names. If so, add them here. This is a comma separated list of names
    1. Module comments: Any comments you want to add to the module index CSV file
    1. Owner secondary GitHub handle: This is optional. If the module owner has a secondary GitHub handle
    1. Owner secondary display name: This is optional. If the module owner has a secondary display name

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

### 3. Request the GitHub App Install

1. Create a new issue at <https://github.com/microsoft/github-operations/issues/new?template=GitHub-App-Installation-Request.md>
1. Update the issue with the following details:
    1. Title: `[GitHub App] Installation Request - Azure Verified Modules`
    1. Body - replace `<repository url>` with the URL of the repository you created in step 2:

        ```markdown
        > __Note:__ If the app is listed on the [Auto-Approved list](https://docs.opensource.microsoft.com/github/apps/approvals/), you do not need to complete this form.

        You complete these steps:

        - [x] Confirm the app is not in the [Auto-Approved list](https://docs.opensource.microsoft.com/github/apps/approvals/)
        - [x] Fill out and verify the information in this form
        - [x] Update the title to reflect the org/repo and/or app name
        - [x] Submit the native request within the GitHub user interface

        Operations will help complete these steps:

        - [ ] Approve the app if already requested on GitHub natively
        - [ ] Close this issue

        Finally, you'll complete any configuration with the app or your repo that is required once approved.

        # My request

        - GitHub App name: Azure Verified Modules

        - GitHub organization in which the app would be installed: Azure

        - Is this an app created by you and/or your team?

          - [x] Yes, this is an app created by me and/or my team
          - [ ] No, this is a Microsoft 1st-party app created by another team
          - [ ] No, this is a 3rd-party marketplace app

        - If this __is an app created by you and/or your team__, please provide some ownership information in case future questions come up:

          - Service Tree ID: our service tree ID is: Unchanged
          - A few specific individuals at Microsoft if we have questions (corporate email list):Unchanged
          - An optional team discussion list: Unchanged

        - Is this an app you/your team created to address [reduced PAT lifetimes](https://aka.ms/opensource/tsg/pat)?
          - [x] Yes
          - [ ] No

        - Are you looking for this app to be installed on individual repos or all repos in an organization?

          - [x] Individual repos: <repository url>
          - [ ] All repos in an organization

        - Does this app have any side-effects if it is installed into all repos in an organization? Side effects can include creating labels, issues, pull requests, automatic checks on PRs, etc.

          - [ ] Yes, it has side effects and you should be careful if installing to all repos in an org
          - [x] No side effects

        - Please provide a description of the app's functionality and what are you trying to accomplish by utilizing this app:

          Unchanged

        - For any major permissions (org admin, repo admin, etc.), can you explain what they are and why they are needed?

          Unchanged

        - Any other notes or information can you provide about the app?
        ```

1. Submit the issue

### 4. Notify the Module Owner and Update the Issue Status

1. Add a comment to the issue you found in step 1 to let the module owner know that the repository has been created and is be ready for them to start development.

    ```markdown
    @<module owner> The module repository has now been created. You can find it at <repository url>.

    The final step of repository configuration is still in progress, but you will be able to start developing your code immediately.

    The final step is to create the environment and credentials require to run the end to end tests. If the environment called `test` is not available in 48 hours, please let me know.

    Thanks
    ```

1. Add the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#27AB03;color:white;">Status: Repository Created 📄</mark>&nbsp; label to the issue
1. Remove the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#136A41;color:white;">Status: Ready For Repository Creation 📝</mark>&nbsp; label from the issue

### 5. Merge the Pull Request for the metadata CSV file

1. Open the pull request for the metadata CSV file shown in the script output look [here](https://github.com/Azure/avm-terraform-governance/pulls) if you lost the link
1. Review the changes to ensure they are correct and only adding 1 new line for the module you just created
1. If everything looks good, merge the pull request

### 6. Wait for the GitHub App to be installed

Once the GitHub App has been installed, the sync to create the environment and credentials will be triggered automatically at 15:30 UTC on week days. However, you can also trigger it manually by running the following command in the `tf-repo-mgmt` folder:

```pwsh
$moduleName = "avm-res-network-virtualnetwork" # Replace with the module name (do not include the "terraform-azurerm" prefix)

./scripts/Invoke-WorkflowDispatch.ps1 `
  -inputs @{
    repositories = "$moduleName"
    plan_only = $false
  }
```
