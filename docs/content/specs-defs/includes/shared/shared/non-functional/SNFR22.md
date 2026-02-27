---
title: SNFR22 - Parameters/Variables for Resource IDs
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SNFR22
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1180
---

## ID: SNFR22 - Category: Inputs - Parameters/Variables for Resource IDs

A module parameter/variable that requires a full Azure Resource ID as an input value, e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}`, **MUST** contain `ResourceId/resource_id` in its parameter/variable name when that parameter/variable is part of a **user-defined** type. This assists users in knowing what value to provide at a glance of the parameter/variable name.

Example for the property `workspaceId` for the Diagnostic Settings resource in a **user-defined** type: in Bicep its parameter name should be `workspaceResourceId` and the variable name in Terraform should be `workspace_resource_id`.

In that user-defined context, `workspaceId` is not descriptive enough and is ambiguous as to which ID is required to be input.

### Special considerations for Bicep

If the property is nested in a parameter and you opt for a **resource-derived** type (that is, a schema defined by the resource provider), this requirement does not apply. We do however recommend to use a **user-defined** type whenever these cases occur to increase the module's usability.

Example for the property `subnetArmId` of the Cognitive Service's property `networkInjections`:

If using a **user-defined** type, you may define a type for the `networkInjections` parameter like
```bicep
param networkInjections networkInjectionType?

@export()
type networkInjectionType = {
  subnetResourceId: string

  // (...)
}

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  // (...)
  properties: {
    // (...)
    networkInjections: [{
      subnetArmId: networkInjections.?subnetResourceId
      // (...)
    }]
  }
}
```
or a **resource-derived** type like
```bicep
param networkInjections resourceInput<'Microsoft.CognitiveServices/accounts@2025-06-01'>.properties.networkInjections

resource cognitiveService 'Microsoft.CognitiveServices/accounts@2025-06-01' = {
  // (...)
  properties: {
    // (...)
    networkInjections: networkInjections
  }
}
```
