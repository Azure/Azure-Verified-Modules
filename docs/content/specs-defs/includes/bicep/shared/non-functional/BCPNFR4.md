---
title: BCPNFR4 - Parameter Input Examples
url: /spec/BCPNFR4
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Documentation,
  Language-Bicep,
  Severity-MAY,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 11050
---

#### ID: BCPNFR4 - Category: Documentation - Parameter Input Examples

Bicep modules **MAY** provide parameter input examples for parameters using the `metadata.example` property via the `@metadata()` decorator.

Example:

```bicep
@metadata({
  example: 'uksouth'
})
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@metadata({
  example: '''
  {
    keyName: 'myKey'
    keyVaultResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/my-rg/providers/Microsoft.KeyVault/vaults/myvault'
    keyVersion: '6d143c1a0a6a453daffec4001e357de0'
    userAssignedIdentityResourceId '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
  }
  '''
})
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType
```

It is planned that these examples are automatically added to the module readme's parameter descriptions when running either the `Set-ModuleReadMe` or `Set-AVMModule` scripts (available in the utilities folder).
