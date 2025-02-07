---
draft: false
title: Bicep Quickstart Guide
linktitle: Bicep
weight: 1
description: Bicep Quickstart Guidance for the Azure Verified Modules (AVM) program
---

## Introduction

This guide explains how to use an Azure Verified Module (AVM) in your Bicep workflow. By leveraging AVM modules, you can rapidly deploy and manage Azure infrastructure without having to write extensive code from scratch.

In this guide, you will deploy a [Key Vault](https://learn.microsoft.com/en-us/azure/key-vault/general/) resource and a Personal Access Token as a secret.

This article is intended for a typical 'infra-dev' user (cloud infrastructure professional) who has a basic understanding of Azure and Bicep but is new to Azure Verified Modules and wants to learn how to deploy a module in the easiest way using AVM.

For additional Bicep learning resources use the [Bicep documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/) on the Microsoft Learn platform, or leverage the [Fundamentals of Bicep](https://learn.microsoft.com/en-us/training/paths/fundamentals-bicep/) learning path.

## Prerequisites

You will need the following tools and components to complete this quickstart guide:

- [Visual Studio Code (VS Code)](https://code.visualstudio.com/download) to develop your solution.
- [Bicep Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to author your Bicep template and explore modules published in the [Registry](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules#public-module-registry).
- One of the following command line tools:
  - [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell) AND [Azure PowerShell](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell)
  - [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) to deploy your solution.
- [Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#install-manually)
- [Azure Subscription](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) to deploy your Bicep template.

Make sure you have these tools set up before proceeding.

## Module Discovery

### Find your module

In this scenario, you need to deploy a Key Vault resource and some of its child resources, such as a secret. Let's find the AVM module that will help us achieve this.

There are two primary ways for locating published Bicep Azure Verified Modules:

- Option 1 (preferred): Using IntelliSense in the Bicep extension of Visual Studio Code, and
- Option 2: browsing the [AVM Bicep module index](https://aka.ms/avm/moduleindex/bicep).

#### Option 1: Use the Bicep Extension in VS Code

<video width=100% controls muted preload="metadata">
    <source src="{{% siteparam base %}}/images/usage/quickstart/bicep/key-vault-vscode-bcp-1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

1. In VS Code, create a new file called `main.bicep`.
1. Start typing `module`, then give your module a symbolic name, such as `myModule`.
1. Use IntelliSense to select `br/public`.
1. The list of all AVM modules published in the Bicep Public Registry will show up. Use this to explore the published modules.
    {{% notice style="note" %}}
The Bicep VSCode extension is reading metadata through [this JSON file](https://live-data.bicep.azure.com/module-index). All modules are added to this file, as part of the publication process. This lists all the modules marked as Published or Orphaned on the [AVM Bicep module index pages](https://aka.ms/AVM/ModuleIndex/Bicep).
    {{% /notice %}}
2. Select the module you want to use and the version you want to deploy. Note how you can type full or partial module names to filter the list.
3. Right click on the module's path and select `Go to definition` or hit `F12` to see the module's source code. You can toggle between the Bicep and the JSON view.
4. Hover over the module's symbolic name to view its documentation URL. By clicking on it, you will be directed to the module's GitHub folder in the [bicep-registry-modules (BRM)](https://aka.ms/BRM) repository. There, you can access the source code and documentation, as illustrated [below](#module-details-and-examples).

#### Option 2: Use the AVM Bicep Module Index

<video width=100% controls muted preload="metadata">
    <source src="{{% siteparam base %}}/images/usage/quickstart/bicep/module-index_bcp_res_1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

Searching the Azure Verified Module indexes is the most complete way to discover published as well as planned (proposed) modules. As shown in the video above, use the following steps to locate a specific module on the AVM website:

1. Open the AVM website in your favorite web browser: [https://aka.ms/avm](https://aka.ms/avm).
1. Expand the **Module Indexes** menu item and select the **Bicep** sub-menu item.
1. Select the menu item for the module type you are searching for: [Resource]({{% siteparam base %}}/indexes/bicep/bicep-resource-modules/), [Pattern]({{% siteparam base %}}/indexes/bicep/bicep-pattern-modules/), or [Utility]({{% siteparam base %}}/indexes/bicep/bicep-utility-modules/).
  {{% notice style="note" %}}Since the Key Vault module used as an example in this guide is published as an AVM resource module, it can be found under the [resource modules]({{% siteparam base %}}/indexes/bicep/bicep-resource-modules/) section in the AVM Bicep module index.{{% /notice %}}
1. A detailed description of module classification types can be found under the related section [here]({{% siteparam base %}}/specs/shared/module-classifications/).
1. Select the **Published modules** link from the table of contents at the top of the page.
1. Use the in-page search feature of your browser. In most Windows browsers you can access it using the `CTRL` + `F` keyboard shortcut.
1. Enter a **search term** to find the module you are looking for - e.g., Key Vault.
1. **Move through the search results until you locate the desired module.**  If you are unable to find a published module, return to the table of contents and expand the **All modules** link to search both published and proposed modules - i.e., modules that are planned, likely in development but not published yet.
1. After finding the desired module, click on the **module's name**. This link will lead you to the module's folder in the [bicep-registry-modules (BRM)](https://aka.ms/BRM) repository, where the module's [source code](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault) and [documentation](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md) can be found, including [usage examples](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md#Usage-examples).

### Module details and examples

<video width=100% controls muted preload="metadata">
    <source src="{{% siteparam base %}}/images/usage/quickstart/bicep/key-vault-readme-bcp-1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

In the module's documentation, you can find detailed information about the module's functionality, components, input parameters, outputs and more. The documentation also provides comprehensive usage examples, covering various scenarios and configurations.

Explore the Key Vault module’s documentation for usage examples and to understand its functionality, input parameters, and outputs.

  1. Note the mandatory and optional parameters in the [**Parameters**](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md#Parameters) section.

  1. Review the [**Usage examples**](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md#Usage-examples) section. AVM modules include multiple tests that can be found under the **`tests`** folder. These tests are also used as the basis of the usage examples ensuring they are always up-to-date and deployable.

In this example, you will deploy a secret in a new Key Vault instance with minimal input. AVM provides default parameter values with security and reliability being core principles. These settings apply the recommendations of the [Well Architected Framework]({{% siteparam base %}}/faq/#what-does-avm-mean-by-waf-aligned) where possible and appropriate.

Note how [Example 2](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-2-using-only-defaults) does most of what you need to achieve.

## Create your new solution using AVM

In this section, you will develop a Bicep template that references the AVM Key Vault module and its child resources and features. These include secret and role based access control configurations that grant permissions to a user.

1. Start VSCode (make sure the Bicep extension is installed) and open a folder in which you want to work.
1. Create a `main.bicep` and a `dev.bicepparam` file, which will hold parameters for your Key Vault deployment.
1. Copy the content below into your `main.bicep` file. We have included comments to distinguish between the two different occurrences of the `names` attribute.

<!-- {lineNos=inline} -->
```bicep
module myKeyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: // the name of the module's deployment
  params: {
    name: '<keyVaultName>' // the name of the Key Vault instance - length and character limits apply
  }
}
```

  {{% notice style="note" %}}For Azure Key Vaults, the name must be globally unique. When you deploy the Key Vault, ensure you select a name that is alphanumeric, twenty-four characters or less, and unique enough to ensure no one else has used the name for their Key Vault. If the name has been previously taken, you will get an error.{{% /notice %}}

After setting the values for the required properties, the module can be [deployed](#deploy-your-solution). This minimal configuration automatically applies the security and reliability recommendations of the [Well Architected Framework]({{% siteparam base %}}/faq/#what-does-avm-mean-by-waf-aligned) where possible and appropriate. These settings can be overridden if needed.

{{% notice style="note" title="Bicep-specific configuration" %}}

It is recommended to create a [`bicepconfig.json`](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config) file, and enable *use-recent-module-versions*, which warns you to use the latest available version of the AVM module.

```json
// This is a Bicep configuration file. It can be used to control how Bicep operates and to customize
// validation settings for the Bicep linter. The linter relies on these settings when evaluating your
// Bicep files for best practices. For further information, please refer to the official documentation at:
// https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config
{
  "analyzers": {
    "core": {
      "rules": {
        "use-recent-module-versions": {
          "level": "warning",
          "message": "The module version is outdated. Please consider updating to the latest version."
        }
      }
    }
  }
}
```

{{% /notice %}}

### Define the Key Vault instance

In this scenario - and every other real-world setup - there is more that you need to configure. You can open the module's documentation by hovering over its symbolic name to see all of the module’s capabilities - including supported parameters.

{{% notice style="note" %}}The Bicep extension facilitates code-completion, enabling you to easily locate and utilize the Azure Verified Module. This feature also provides the necessary properties for a module, allowing you to begin typing and leverage IntelliSense for completion.{{% /notice %}}

1. Add parameters and values to the `main.bicep` file to customize your configuration. These parameters are used for passing in the Key Vault name and enabling purge protection. You might not want to enable the latter in a non-production environment, as it makes it harder to delete and recreate resources.

The `main.bicep` file will now look like this:

<!-- {lineNos=inline} -->
```bicep
// the scope, the deployment deploys resources to
targetScope = 'resourceGroup'

// parameters and default values
param keyVaultName string

@description('Disable for development deployments.')
param enablePurgeProtection bool = true

// the resources to deploy
module myKeyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: 'key-vault-deployment'
  params: {
    name: keyVaultName
    enablePurgeProtection: enablePurgeProtection
    // more properties are not needed, as AVM provides default values
  }
}
```

Note that the Key Vault instance will be deployed within a resource group scope in our example.

2. Create a `dev.bicepparam` file (this is optional) and set parameter values for your environment. You can now pass these values by referencing this file at the time of deployment (using PowerShell or Azure CLI).

<!-- {lineNos=inline} -->
```bicep
using 'main.bicep'

// environment specific values
param keyVaultName = '<keyVaultName>'
param enablePurgeProtection = false
```

### Create a secret and set permissions

Add a secret to the Key Vault instance and grant permissions to a user to work with the secret. Sample role assignments can be found in [Example 3: Using large parameter set](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-3-using-large-parameter-set). See [Parameter: roleAssignments](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#parameter-roleassignments) for a list of pre-defined roles that you can reference by name instead of a GUID. This is a key benefit of using AVM, as the code is easy to read and increases the maintainability.

You can also leverage [User-defined data types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) and simplify the parameterization of the modules instead of guessing or looking up parameters. Therefore, first import UDTs from the Key Vault and common types module and leverage the UDTs in your Bicep and parameter files.

For a role assignment, the principal ID is needed, that will be granted a role (specified by its name) on the resource. Your own ID can be found out with `az ad signed-in-user show --query id`.

<!-- {lineNos=inline} -->
```bicep
// the scope, the deployment deploys resources to
targetScope = 'resourceGroup'

// parameters and default values
param keyVaultName string
// the PAT token is a secret and should not be stored in the Bicep(parameter) file.
// It can be passed via the commandline, if you don't use a parameter file.
@secure()
param patToken string = newGuid()

@description('Enabled by default. Disable for development deployments')
param enablePurgeProtection bool = true

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
// the role assignments are optional in the Key Vault module
param roleAssignments roleAssignmentType[]?

// the resources to deploy
module myKeyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: 'key-vault-deployment'
  params: {
    name: keyVaultName
    enablePurgeProtection: enablePurgeProtection
    secrets: [
      {
        name: 'PAT'
        value: patToken
      }
    ]
    roleAssignments: roleAssignments
  }
}
```

The secrets parameter references a UDT ([User-defined data type](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types)) that is part of the Key Vault module and enables code completion for easy usage. There is no need to look up what attributes the secret object might have. Start typing and tab-complete what you need from the content offered by the Bicep extension's integration with AVM.

The bicep parameter file now looks like this:

<!-- {lineNos=inline} -->
```bicep
// reference to the Bicep file to set the context
using 'main.bicep'

// environment specific values
param keyVaultName = '<keyVaultName>'
param enablePurgeProtection = false
// for security reasons, the secret value must not be stored in this file.
// You can change it later in the deployed Key Vault instance, where you also renew it after expiration.

param roleAssignments = [
  {
    principalId: '<principalId>'
    // using the name of the role instead of looking up the GUID (which can also be used)
    roleDefinitionIdOrName: 'Key Vault Secrets Officer'
  }
]
```

{{% notice style="note" %}}
The display names for roleDefinitionIdOrName can be acquired the following two ways:

- From the [parameters section](https://github.com/Azure/bicep-registry-modules/blob/avm/res/key-vault/vault/0.11.0/avm/res/key-vault/vault/README.md#parameter-roleassignments) of the module's documentation.
- From the `builtInRoleNames` variable in the module's source code. To get there, hit `F12` while the cursor is on the part of the module path starting with `br/public:`.
{{% /notice %}}

### Boost your development with VS Code IntelliSense

Leverage the IntelliSense feature in VS Code to speed up your development process. IntelliSense provides code completion, possible parameter values and structure. It helps you write code more efficiently by providing context-aware suggestions as you type.

Here is how quickly you can deliver the solution detailed in this section:

<video width=100% controls muted preload="metadata">
    <source src="{{% siteparam base %}}/images/usage/quickstart/bicep/kv-and-secret-vs-code-intellisense-bcp-1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

## Deploy your solution

Now that your template and parameter file is ready, you can deploy your solution to Azure. Use PowerShell or the Azure CLI to deploy your solution.

{{% tabs title="Deploy with" groupid="scriptlanguage" %}}
  {{% tab title="PowerShell" %}}

  ```powershell
  # Log in to Azure
  Connect-AzAccount

  # Select your subscription
  Set-AzContext -SubscriptionId '<subscriptionId>'

  # Deploy a resource group
  New-AzResourceGroup -Name 'avm-quickstart-rg' -Location 'germanywestcentral'

  # Invoke your deployment
  New-AzResourceGroupDeployment -DeploymentName 'avm-quickstart-deployment' -ResourceGroupName 'avm-quickstart-rg' -TemplateParameterFile 'dev.bicepparam' -TemplateFile 'main.bicep'
  ```

  {{% /tab %}}
  {{% tab title="AZ CLI" %}}

  ```bash
  # Log in to Azure
  az login

  # Select your subscription
  az account set --subscription '<subscriptionId>'

  # Deploy a resource group
  az group create --name 'avm-quickstart-rg' --location 'germanywestcentral'

  # Invoke your deployment
  az deployment group create --name 'avm-quickstart' --resource-group 'avm-quickstart-rg' --template-file 'main.bicep' --parameters 'dev.bicepparam'
  ```

  {{% /tab %}}
{{% /tabs %}}

Use the Azure portal, Azure PowerShell, or the Azure CLI to verify that the Key Vault instance and secret have been successfully created with the correct configuration.

## Clean up your environment

When you are ready, you can remove the infrastructure deployed in this example. The following commands will remove all resources created by your deployment:

{{% tabs title="Clean up with" groupid="scriptlanguage" %}}
  {{% tab title="PowerShell" %}}

  ```powershell
  # Delete the resource group
  Remove-AzResourceGroup -Name "avm-quickstart-rg" -Force

  # Purge the Key Vault
  Remove-AzKeyVault -VaultName "<keyVaultName>" -Location "germanywestcentral" -InRemovedState -Force
  ```

  {{% /tab %}}
  {{% tab title="AZ CLI"%}}

  ```bash
  # Delete the resource group
  az group delete --name 'avm-quickstart-rg' --yes --no-wait

  # Purge the Key Vault
  az keyvault purge --name '<keyVaultName>' --no-wait
  ```

  {{% /tab %}}
{{% /tabs %}}

Congratulations, you have successfully leveraged an AVM Bicep module to deploy resources in Azure!

{{% notice style="tip" %}}
We welcome your contributions and feedback to help us improve the AVM modules and the overall experience for the community!
{{% /notice %}}

## Next Steps

For developing a more advanced solution, please see the lab titled "[Introduction to using Azure Verified Modules for Bicep](https://aka.ms/AVM/Bicep/labs)".
