---
title: Bicep Quickstart
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 2
geekdocCollapseSection: true
---

{{< toc >}}

With a task in mind, I need to deploy a Key Vault instance. This Quickstart-Guide shows how to deploy an instance with an Azure Verified Module.

## How do I find out which modules exist?

Available modules (currently we don't distinguish between Resource, Pattern and Utility modules) are listed on the [Bicep Modules](/Azure-Verified-Modules/indexes/bicep/) site.

With a task in mind, I need to deploy a Key Vault instance.

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