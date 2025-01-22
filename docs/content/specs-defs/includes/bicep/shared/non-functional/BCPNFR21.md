---
title: BCPNFR21 - User-defined types - Decorators
url: /spec/BCPNFR21
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 11010
---

#### ID: BCPNFR21 - User-defined types - Decorators

Similar to [BCPNFR9]({{% siteparam base %}}/spec/BCPNFR9), User-defined types (UDTs) MUST implement [decorators](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters#use-decorators) such as `description` & `secure` (if sensitive). This is true for every property of the UDT, as well as the UDT itself.

Further, User-defined types SHOULD implement decorators like `allowed`, `minValue`, `maxValue`, `minLength` & `maxLength` (and others if available) as they have a big positive impact on the module's usability.

```bicep
@description('My type''s description.')
type myType = {
  @description('Optional. The threshold of your resource.')
  @minValue(1)
  @maxValue(10)
  threshold: int?

  @description('Required. The SKU of your resource.')
  sku: ('Basic' | 'Premium' | 'Standard')
}
```
