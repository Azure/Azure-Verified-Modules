---
title: BCPNFR4 - Parameter Input Examples
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPNFR4
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Documentation, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MAY, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11050
---

## ID: BCPNFR4 - Category: Documentation - Parameter Input Examples

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
