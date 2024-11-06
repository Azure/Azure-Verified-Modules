---
title: Bicep Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 2
geekdocCollapseSection: true
---

{{< toc >}}

This Quickstart-Guide shows how to deploy an instance with an Azure Verified Module. Let's assume, we need to deploy a [Key Vault](https://azure.microsoft.com/en-us/products/key-vault/) instance.

## Requirements

You can use any text editor, but for this Quickstart VSCode will be used.

- [Visual Studio Code](https://code.visualstudio.com/download)
- [Bicep](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep) Extension for VSCode (not needed, but it provides intellisense)

## How do I find out which modules exist?

With the scenario in mind, I need to deploy a Key Vault instance. Available modules (for now, we don't distinguish between resource, pattern and utility modules) are listed on the [Bicep Modules](/Azure-Verified-Modules/indexes/bicep/) site. Searching on this site for *key-vault* .

![Searching key-vault on the Bicep module index](/Azure-Verified-Modules/img/quickstart/bicep_modules_keyvault_search.png)

{{< hint type=info icon=gdoc_info_outline title="Searching the AVM Website" >}}
The AVM team is working on improving the overall search experience, which will allow you to search for e.g. '*key vault*' instead of '*key-vault*'.
{{< /hint >}}

We now know there is a resource module for Key Vault. 

- examples
- what if my module isn't available?

## Using a module

[Bicep Modules](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/modules)



- what are the built-in features of the key-vault module
- UDTs
- intellisense

### Module deep-dive
are stored in a central Azure Container Registry.
- explore the source of the kv module without leaving VS code
  - how can I see the readme of the kv module from vs code
  - what if there's a missing feature? --> file a module issue
