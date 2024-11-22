---
title: Bicep Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 2
geekdocCollapseSection: true
---

{{< toc >}}

This Quickstart-Guide shows how to deploy an instance with an Azure Verified Module. Let's assume, we need to deploy a [Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) instance to store a Personal Access Token.

## Requirements

You can use any text editor, but for this Quickstart VSCode will be used.

- [Visual Studio Code](https://code.visualstudio.com/download)
- [Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) Extension for VSCode (not needed, but it provides intellisense)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)

## How do I find out which modules exist?

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

We want to deploy a secret in a new Key Vault instance, without thinking much about the other parameters. Fortunately, AVM has covererd us in terms of Security and Reliability, as the default settings apply best-practices from the [Well Architected Framework](https://learn.microsoft.com/en-us/azure/well-architected/).

The [Example 2](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-2-using-only-defaults) seems to do pretty much what we want to achieve.

## Start coding

1. Fire up VSCode (with the Bicep extension installed) and open a folder in which you want to work.
2. Create a `main.bicep` and a `dev.bicepparam` file.

The scope for the deployment of the Key Vault instance will be a resource group. The Bicep extension offers code-completion, which makes it easy to find and use the Azure Verified Module.

![Code-Completion in Visual Studio Code](/Azure-Verified-Modules/img/usage-guide/quickstart/bicep_module_vscode_code_completion.png)

### The Basics

Select the latest version and start building the script. The ```main.bicep``` might look like this:

```bicep
targetScope = 'resourceGroup'

param keyVaultName string?
param resourceLocation string = resourceGroup().location

@description('Disable for development deployments')
param enablePurgeProtection bool = true

module keyVault 'br/public:avm/res/key-vault/vault:0.10.2' = {
  name: 'key-vault-deployment'
  params: {
    // generate the name, if not explicitly specified
    name: keyVaultName ?? uniqueString('kv', subscription().id, resourceGroup().name)
    location: resourceLocation
    enablePurgeProtection: enablePurgeProtection
  }
}

output keyVaultName string = keyVault.name
```

The ```dev.bicepparam``` file is optional. You can instead pass parameters to the CLI.

```bicep
using 'main.bicep'

param enablePurgeProtection = false
```

To test the script and deploy it to Azure, you can use the Azure CLI:

```bash
az group create --name avm-quickstart-rg --location germanywestcentral
az deployment group create --resource-group avm-quickstart-rg --template-file main.bicep --parameters dev.bicepparam
```

### Finalize the template

Now let's add the key and grant permissions to a user to work with the key. Sample role assignements can be found in [Example 3: Using large parameter set](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#example-3-using-large-parameter-set). See [Parameter: roleAssignments](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/key-vault/vault#parameter-roleassignments) for a list of pre-defined roles, that you can reference by name.

For a role assignment, the principal ID is needed, that will be granted a role on the resource. Your own ID can be found out with `az ad signed-in-user show --query id`.

```bicep
targetScope = 'resourceGroup'

param keyVaultName string?
param resourceLocation string = resourceGroup().location

@description('Disable for development deployments')
param enablePurgeProtection bool = true

import { keyType } from 'br/public:avm/res/key-vault/vault:0.11.0'
param keys keyType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
param roleAssignments roleAssignmentType[]?

module keyVault 'br/public:avm/res/key-vault/vault:0.10.2' = {
  name: 'key-vault-deployment'
  params: {
    // generate the name, if not explicitly specified
    name: keyVaultName ?? uniqueString('kv', subscription().id, resourceGroup().name)
    location: resourceLocation
    enablePurgeProtection: enablePurgeProtection
    keys: keys
    roleAssignments: roleAssignments
  }
}

output keyVaultName string = keyVault.name
```

And the bicep parameter file now looks like this:

```bicep
using 'main.bicep'

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
    roleDefinitionIdOrName: 'Key Vault Crypto Officer'
  }
]
```

With this IaC template (Infrastructure as Code), you deploy a Key Vault instance, add a key and grant permissions to a user.

### Usage deep-dive

- UDTs

are stored in a central Azure Container Registry.

- explore the source of the kv module without leaving VS code
  - how can I see the readme of the kv module from vs code
  - what if there's a missing feature? --> file a module issue
