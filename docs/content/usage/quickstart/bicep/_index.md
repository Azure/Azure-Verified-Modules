---
title: Bicep Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 2
---

{{< toc >}}

## Introduction

This guide shows how to deploy an Azure Verified Module. By leveraging AVM modules, you can rapidly deploy and manage Azure infrastructure without having to write extensive code from scratch.

In this guide, we'll deploy deploy a [Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) resource and a Personal Access Token as a secret.

This article is written for a typical "infra-dev" user (cloud infrastructure professional) who is new to Azure Verified Modules and wants learn how to deploy a module the easiest possible way using AVM. The user has a basic understanding of Azure and Bicep templates.

If you first need to learn Bicep, you can find a [Bicep Quickstart](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/quickstart-create-bicep-use-modules) on the Microsoft Learn platform, study the [detailed documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/file), or leverage the [Fundamentals of Bicep](https://learn.microsoft.com/en-us/training/paths/fundamentals-bicep/) learning path.

## Prerequisites

For the best experience, you will need:

- [Visual Studio Code (VS Code)](https://code.visualstudio.com/download) to develop your solution.
- [Bicep Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to author your Bicep template and explore modules published in the [registry](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules#public-module-registry).
- [PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell) OR [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) to deploy your solution.
- [Azure Subscription](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/considerations/fundamental-concepts) to deploy your Bicep template.

Make sure you have these tools set up before proceeding.

## Module Discovery

### Find your module

With our scenario in mind, we need to deploy a Key Vault resource and some of its child resources - e.g., a secret. Let's find the AVM module that will help us achieve this.

There are two primary ways for locating published Bicep Azure Verified Modules:

- Option 1 (preferred): Using IntelliSense in the Bicep extension of Visual Studio Code, and
- Option 2: browsing the[AVM Bicep module index](https://aka.ms/avm/moduleindex/bicep).

#### Option 1: Use the Bicep Extension in VS Code

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/bicep/key-vault-vscode-bcp-1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

1. In VS Code, create a new file with called `main.bicep`.
1. Start typing `module`, then give your module a symbolic name, such as `myModule`.
1. Use Intellisense to select `br/public`.
1. The list of all AVM modules published in the Bicep Public Registry will show up. Use this to explore the published modules.
  {{< hint type=note >}}The Bicep VSCode extension is reading metadata through [this JSON file](https://live-data.bicep.azure.com/module-index). All modules are added to this file, as part of the publication process. This lists all the modules marked as Published or Orphaned on the [AVM Bicep module index pages](https://aka.ms/AVM/ModuleIndex/Bicep).{{< /hint >}}
1. Select the module you want to use and the version you want to deploy. Note how you can type full or partial module names to filter the list.
1. Right click on the module's path and select `Go to definition` or hit `F12` to see the module's source code. You can toggle between the Bicep and the JSON view.
1. Hover over the module's symbolic name to see the module's documentation URL. Clicking on it leads you to the module's GitHub folder in the [bicep-registry-modules (BRM)](https://aka.ms/BRM) repository, where its source code and documentation are stored as shows [below](#module-details-and-examples).

#### Option 2: Use the AVM Bicep Module Index

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/bicep/module-index_bcp_res_1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

Searching the Azure Verified Module indexes is the most complete way to discover published as well as planned (proposed) modules. As shown in the video above, use the following steps to locate a specific module on the AVM website:

- Use your web browser to open the AVM website at [https://aka.ms/avm](https://aka.ms/avm).
- Expand the **Module Indexes** menu item and select the **Bicep** sub-menu item.
- Select the menu item for the module type you are searching for: [Resource](/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/), [Pattern](/Azure-Verified-Modules/indexes/bicep/bicep-pattern-modules/), or [Utility](/Azure-Verified-Modules/indexes/bicep/bicep-utility-modules/).
  {{< hint >}}Since the Key Vault module used as an example in this guide is published as an AVM resource module, it can be found under the [resource modules](/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/) section in the AVM Bicep module index.{{< /hint >}}
- A detailed description of each module classifications types can be found under the related section [here](https://azure.github.io/Azure-Verified-Modules/specs/shared/module-classifications/).
- Select the **Published modules** link from the table of contents at the top of the page.
- Use the in-page search feature of your browser. In most Windows browsers you can access it using the `CTRL` + `F` keyboard shortcut.
- Enter a **search term** to find the module you are looking for - e.g., Key Vault.
- **Move through the search results until you locate the desired module.**  If you are unable to find a published module, return to the table of contents and expand the **All modules** link to search both published and proposed modules - i.e., modules that are planned, likely in development but not published yet.
- After finding the desired module, click on the **module's name**. The link will lead you to the module's GitHub folder in the [bicep-registry-modules (BRM)](https://aka.ms/BRM) repository, where its [source code](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault) its stored along with its [documentation](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md) that also includes [usage examples](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md#Usage-examples).

### Module details and examples

<video width=100% controls muted preload="metadata">
    <source src="/Azure-Verified-Modules/img/usage/quickstart/bicep/key-vault-readme-bcp-1080-10fps.mp4" type="video/mp4">
    Your browser does not support the video tag.
</video>

In the module's documentation, you can find detailed information about the module's functionality, components, input parameters, outputs and more. The documentation also provides comprehensive usage examples, covering various scenarios and configurations.

Explore the Key Vault module’s documentation for usage examples and to understand its functionality, input parameters, and outputs.

- Note the mandatory and optional parameters in the [**Parameters**](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md#Parameters) section.
- Review [**Usage examples**](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/key-vault/vault/README.md#Usage-examples). AVM modules are developed including multiple tests. They can be found under the **`tests`** folder and are used as the basis of the usage examples, therefore they are always up-to-date and deployable.

We want to deploy a secret in a new Key Vault instance, without needing to provide other parameters. Fortunately, AVM has got us covered in terms of Security and Reliability, as the default settings apply best-practices from the [Well Architected Framework](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned).

Note how [Example 2](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-2-using-only-defaults) seems to do pretty much what we want to achieve.

## Develop your new template using AVM

1. Start up VSCode (with the Bicep extension installed) and open a folder in which you want to work.
2. Create a `main.bicep` and a `dev.bicepparam` file, which will hold parameters for your Key Vault deployment.

The scope for the deployment of the Key Vault instance will be a resource group. The Bicep extension offers code-completion, which makes it easy to find and use the Azure Verified Module. It will e.g. provide the required properties for a module. You can start typing, let the magic do its thing and end up with (we've added comments here, to describe the different names):

```bicep {lineNos=inline}
module keyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: // the name of the deployment
  params: {
    name: // the name of the Key Vault instance with constraints like maximum length and the data type
  }
}
```

After setting the values for the required properties, the module can be deployed. This minimal configuration automatically sets best-practices from the [Azure Well-Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/) for reliability and security with default values, which you can always override.

{{< hint type=note >}}
The Bicep VSCode extension is reading metadata through [this JSON file](https://live-data.bicep.azure.com/module-index). All modules are added to this file, as part of the publication process. This lists all the modules marked as Published or Orphaned on the [AVM Bicep module index pages](https://aka.ms/AVM/ModuleIndex/Bicep).
{{< /hint >}}

### Define the Key Vault instance

In this scenario, and every other real-world setup, there is a bit more that we want to configure. You can use the documentation URL (by hovering over the module) to see the module’s documentation online for other supported parameters. The ```main.bicep``` might look like this:

```bicep {lineNos=inline}
// the scope, the deployment deploys resources to
targetScope = 'resourceGroup'

// parameters and default values
param keyVaultName string
param resourceLocation string = resourceGroup().location

@description('Disable for development deployments.')
param enablePurgeProtection bool = true

// the resources to deploy
module keyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: 'key-vault-deployment'
  params: {
    name: keyVaultName
    location: resourceLocation
    enablePurgeProtection: enablePurgeProtection
    // more properties are not needed, as AVM provides default values
  }
}
```

The code I added makes the module usa is for passing in the Key Vault name and optionally change the location and purge protection. You might not want to enable the latter in a non-production environment, as it makes it harder to delete and recreate resources.

The ```dev.bicepparam``` file is optional and sets parameter values for a certain environment. You can instead pass parameters to the CLI.

```bicep {lineNos=inline}
using 'main.bicep'

// environment specific values
param keyVaultName = '<keyVaultName>'
param enablePurgeProtection = false
```

### Create a key and set permissions

Now let's add a key to the Key Vault instance and grant permissions to a user to work with the key. Sample role assignements can be found in [Example 3: Using large parameter set](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-3-using-large-parameter-set). See [Parameter: roleAssignments](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#parameter-roleassignments) for a list of pre-defined roles, that you can reference by name instead of a Guid. Again, this is a huge advantage of using AVM, as the code is easy to read and increases the maintainability.

You can also make use of [User-defined data types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) and simplify the parameterization of the modules instead of guessing or looking up parameters. Therefore, first import UDTs from the Key Vault and common types module and leverage the UDTs in your Bicep and parameter files.

For a role assignment, the principal ID is needed, that will be granted a role (specified by its name) on the resource. Your own ID can be found out with `az ad signed-in-user show --query id`.

```bicep {lineNos=inline}
// the scope, the deployment deploys resources to
targetScope = 'resourceGroup'

// parameters and default values
param keyVaultName string
param resourceLocation string = resourceGroup().location

@description('Disable for development deployments')
param enablePurgeProtection bool = true

import { keyType } from 'br/public:avm/res/key-vault/vault:0.11.0'
// adding keys is optional in the Key Vault module
param keys keyType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
// the role assignements are optional in the Key Vault module
param roleAssignments roleAssignmentType[]?

// the resources to deploy
module keyVault 'br/public:avm/res/key-vault/vault:0.11.0' = {
  name: 'key-vault-deployment'
  params: {
    name: keyVaultName
    location: resourceLocation
    enablePurgeProtection: enablePurgeProtection
    keys: keys
    roleAssignments: roleAssignments
  }
}
```

Notice the keys parameter, which has a UDT (User-defined data type) that is imported from the Key Vault module and enables again code completion for easy usage. You don't need to lookup the parameters that a key might have. Just start typing and fill whatever you need from the offered parameters by the Bicep extension in combination with Azure Verified Modules.

And the bicep parameter file now looks like this:

```bicep {lineNos=inline}
// reference to the Bicep file to set the context
using 'main.bicep'

// environment specific values
param keyVaultName = '<keyVaultName>'
param enablePurgeProtection = false

param keys = [
  {
    // set required parameters
    kty: 'EC'
    name: 'PAT'
  }
]

param roleAssignments = [
  {
    principalId: '<principalId>'
    // using the name of the role instead of looking up the Guid (which can also be used)
    roleDefinitionIdOrName: 'Key Vault Crypto Officer'
  }
]
```

// TODO I did get the name of the role from code completion (screenshot or something else)

With this IaC template (Infrastructure as Code), you deploy a Key Vault instance, add a key and grant permissions to a user.

## Deploy your module

**\[MB\] TODO: Deploy your Bicep template using PowerShell AND Azure CLI - use example from CARML.**

// TODO add tabbing feature

To test the script and deploy it to Azure, you can use the Azure CLI:

```bash
az group create --name avm-quickstart-rg --location germanywestcentral
az deployment group create --resource-group avm-quickstart-rg --template-file main.bicep --parameters dev.bicepparam
```

To test the script and deploy it to Azure, you can use PowerShell:

```// TODO posh``` with input object https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20usage#powershell

## Bicep-specific configuration

We suggest to create a [`bicepconfig.json`](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config) file, and enable *use-recent-module-versions*, which brings you a warning when not using the latest version of an Azure Verified Module.

```json
// This is a Bicep configuration file. It can be used to control how Bicep operates and to customize validation settings for the Bicep linter. The linter uses these settings when evaluating your Bicep files for best practices.
// For further information, please refer to the official documentation at: https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-config
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

## Clean up your environment

// TODO: Rene to add CLI and PowerShell commands to disable purge protection and delete the resource group
// TODO: Mate to add tabs and explanation

When you're ready, tear down the infrastructure. This will remove all the resources created by your configuration:

**\[MB\] TODO: add PowerShell and Azure CLI commands to tear down the resources deployed**

Congratulations, you have successfully leveraged an AVM Bicep module to deploy resources in Azure!

{{< hint >}}
We welcome your contributions and feedback to help us improve the AVM modules and the overall experience for the community.
{{< /hint >}}
