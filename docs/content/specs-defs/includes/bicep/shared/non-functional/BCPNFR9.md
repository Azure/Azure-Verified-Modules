---
title: BCPNFR9 - Inputs - Decorators
url: /spec/BCPNFR9
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

#### ID: BCPNFR9 - Inputs - Decorators

Similar to [BCPNFR21]({{% siteparam base %}}/spec/BCPNFR21), input parameters MUST implement [decorators](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameters#use-decorators) such as `description` & `secure` (if sensitive).

Further, input parameters SHOULD implement decorators like `allowed`, `minValue`, `maxValue`, `minLength` & `maxLength` (and others if available) as they have a big positive impact on the module's usability.

```bicep
@description('Optional. The threshold of your resource.')
@minValue(1)
@maxValue(10)
param threshold: int?
@description('Required. The SKU of your resource.')
@allowed([
'Basic'
'Premium'
'Standard'
])
param sku string
```
