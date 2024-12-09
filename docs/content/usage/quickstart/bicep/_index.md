---
title: Bicep Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 2
geekdocCollapseSection: true
---

{{< toc >}}

This Quickstart-Guide shows how to deploy an instance with an Azure Verified Module. Let's assume, we need to deploy a [Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) instance and a Personal Access Token.

## Requirements

You can use any text editor, but for this Quickstart, VSCode will be used.

- [Visual Studio Code](https://code.visualstudio.com/download)
- [Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) Extension for VSCode to author your Bicep template and explore modules published in the registry
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) (or PowerShell)
- An Azure subscription to deploy your Bicep template

## How do I find out which modules exist?

// TODO think or check manually, instead of showing the overview page

With the scenario in mind, I need to deploy a Key Vault instance. Available modules (for now, we don't distinguish between resource, pattern and utility modules) are listed on the [Bicep Modules](/Azure-Verified-Modules/indexes/bicep/) site. Searching on this site for *key-vault*.

![Searching key-vault on the Bicep module index](/Azure-Verified-Modules/img/usage-guide/quickstart/bicep_modules_keyvault_search.png)

{{< hint type=info icon=gdoc_info_outline title="Searching the AVM Website" >}}
The AVM team is working on improving the overall search experience, which will allow you to search for e.g. '*key vault*' instead of '*key-vault*'.
{{< /hint >}}

We now know there is a resource module for Key Vault. Next, let's see how it can be used.

## Module details and examples

With the knowledge the module being a resource module, we select *Resource Modules* in the tree-navigation, search for the name again and click the link. This brings us to the GitHub site, where the module source code is stored.

![AVM GitHub page for Key Vault](/Azure-Verified-Modules/img/usage-guide/quickstart/bicep_module_github_module-start-page.png)]

AVMs are developed including multiple tests. They can be used as additional documentation and are stored under the *tests* folder. But let's first look at what the readme for this Key Vault module offers. Scrolling a little bit down, we'll find the **Usage examples** and **Parameters** sections, which provide details about the usage.

Explore the module’s documentation for usage examples and to understand its functionality, input parameters, and outputs.

We want to deploy a secret in a new Key Vault instance, without thinking much about the other parameters. Fortunately, AVM has covererd us in terms of Security and Reliability, as the default settings apply best-practices from the [Well Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/).

The [Example 2](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-2-using-only-defaults) seems to do pretty much what we want to achieve.

## Start coding

1. Fire up VSCode (with the Bicep extension installed) and open a folder in which you want to work.
2. Create a `main.bicep` and a `dev.bicepparam` file, which will hold parameters for a deveploment deployment.

The scope for the deployment of the Key Vault instance will be a resource group. The Bicep extension offers code-completion, which makes it easy to find and use the Azure Verified Module.

![Code-Completion in Visual Studio Code](/Azure-Verified-Modules/img/usage-guide/quickstart/bicep_module_vscode_code_completion.png)

{{< hint type=note >}}
The Bicep VSCode extension is reading metadata through [this JSON file](https://live-data.bicep.azure.com/module-index). All modules are added to this file, as part of the publication process. This lists all the modules marked as Published or Orphaned on the [AVM Bicep module index pages](https://aka.ms/AVM/ModuleIndex/Bicep).
{{< /hint >}}

![Bicep Extension offers](/Azure-Verified-Modules/img/usage-guide/quickstart/bicep_module_vscode_module_hover.png)

// TODO "required-properties" code complete with tab-complete
// TODO something about UDTs like code-completion

Select the latest version and start coding. Set the required properties for the module. You can use the documentation URL to see the module’s documentation online. The ```main.bicep``` might look like this:

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

// output parameters, which give away instance/deployment specific values
output keyVaultName string = keyVault.name
```

The ```dev.bicepparam``` file is optional. You can instead pass parameters to the CLI.

```bicep {lineNos=inline}
using 'main.bicep'

// environment specific values
param keyVaultName = '<keyVaultName>'
param enablePurgeProtection = false
```

// TODO add tabbing feature

To test the script and deploy it to Azure, you can use the Azure CLI:

```bash
az group create --name avm-quickstart-rg --location germanywestcentral
az deployment group create --resource-group avm-quickstart-rg --template-file main.bicep --parameters dev.bicepparam
```

To test the script and deploy it to Azure, you can use PowerShell:

```// TODO posh``` with input object https://github.com/Azure/ResourceModules/wiki/The%20library%20-%20Module%20usage#powershell

### Create a key and set permissions

Now let's add a key to the Key Vault instance and grant permissions to a user to work with the key. Sample role assignements can be found in [Example 3: Using large parameter set](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-3-using-large-parameter-set). See [Parameter: roleAssignments](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#parameter-roleassignments) for a list of pre-defined roles, that you can reference by name.

You can make use of [User-defined data types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) and simplify the parameterization of the modules. Therefore, first import UDTs from the Key Vault and common types module.

For a role assignment, the principal ID is needed, that will be granted a role on the resource. Your own ID can be found out with `az ad signed-in-user show --query id`.

```bicep {lineNos=inline}
// the scope, the deployment deploys resources to
targetScope = 'resourceGroup'

// parameters and default values
param keyVaultName string
param resourceLocation string = resourceGroup().location

@description('Disable for development deployments')
param enablePurgeProtection bool = true

import { keyType } from 'br/public:avm/res/key-vault/vault:0.11.0'
// adding keys is optional in the Key Vault resource module
param keys keyType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
// the role assignements are optional in the Key Vault resource module
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

// output parameters, which give away instance/deployment specific values
output keyVaultName string = keyVault.name
```

And the bicep parameter file now looks like this:

```bicep {lineNos=inline}
using 'main.bicep'

// environment specific values
param keyVaultName = '<keyVaultName>'
param enablePurgeProtection = false

param keys = [
  {
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

## from Máté

### Usage deep-dive

- UDTs

are stored in a central Azure Container Registry.

- explore the source of the kv module without leaving VS code
  - how can I see the readme of the kv module from vs code
  - what if there's a missing feature? --> file a module issue

  <!-- - how do I explore what modules are there?
  - what are the built-in features of the key-vault module
  - UDTs
  - intellisense
  - explore the source of the kv module without leaving VS code
  - how can I see the readme of the kv module from vs code
  - what if there's a missing feature? --> file a module issue -->

To deploy an AVM Bicep module from the Bicep Public Registry, you'll need a few things:

- VS Code and [Bicep Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to author your Bicep template and explore modules published in the registry
- PowerShell or Azure CLI to deploy your Bicep template
- An Azure subscription to deploy your Bicep template

For more details, see the the below example steps.


1. In VS Code, create a new file with the `.bicep` extension - typically named `main.bicep`.
1. Type `module`, then give your module a symbolic name, such as `myTestModule`.
1. Hit `SPACE` then `CTRL+Tab` for the module source list to show up. Select `br/public`.
1. You'll see a list of modules published in the Bicep Public Registry. Use this to explore the published modules.
        {{< hint type=note >}}
The Bicep VSCode extension is reading metadata through [this JSON file](https://live-data.bicep.azure.com/module-index). All modules are added to this file, as part of the publication process. This lists all the modules marked as Published or Orphaned on the [AVM Bicep module index pages](https://aka.ms/AVM/ModuleIndex/Bicep).
    {{< /hint >}}

1. Select the module you want to use and the version you want to deploy.
1. Hover over the module name to see the module's documentation URL.
1. Click on the link to see the module's documentation online.
1. Explore the module's documentation for usage examples and to understand its functionality, input parameters, and outputs.
1. Set the required properties for the module. You can use the documentation URL to see the module's documentation online.

1. Save your `main.bicep` file.
1. Deploy your Bicep template using PowerShell or Azure CLI.
1. Monitor and verify the deployment in the Azure portal or in the terminal you launched it using PowerShell / CLI.
1. Clean up the resources you deployed.
1. Share your feedback with the AVM team and contribute to the AVM Bicep modules.

### Screenshots to be retaken

1. When authoring a new Bicep file, use the [VS Code extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) to explore the modules published in the Bicep Public Registry.
<img src="../../../img/quickstart/bicep/use-bicep-module-01.png" width=100% alt="Select br/public:">

2. Expanding on this you can see the AVM modules that are published.
<img src="../../../img/quickstart/bicep/use-bicep-module-02.png" width=100% alt="Select module from the Public Bicep Registry">

3. Selecting the module expands on the current available versions.
<img src="../../../img/quickstart/bicep/use-bicep-module-03.png" width=100% alt="Choose from the available versions">

4. Setting required properties exposes what is required on the module.
<img src="../../../img/quickstart/bicep/use-bicep-module-04.png" width=100% alt="Select required-properties">

5. Hovering over the `myTestModule` name exposes the module's documentation URL.
<img src="../../../img/quickstart/bicep/use-bicep-module-05.png" width=100% alt="Hover over the module name">

6. Clicking on the link opens up the Bicep Registry Repo for the AVM module's source code, where you can find the documentation detailing all the module's functionality, input parameters and outputs, while providing various examples.
<img src="../../../img/quickstart/bicep/use-bicep-module-06.png" width=100% alt="See the module's documentation online">
