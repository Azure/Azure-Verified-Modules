---
title: TFFR2 - Additional Terraform Outputs
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR2
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 20020
---

## ID: TFFR2 - Category: Outputs - Additional Terraform Outputs

Authors **SHOULD NOT** output entire resource objects as these may contain sensitive outputs and the schema can change with API or provider versions.
Instead, authors **SHOULD** output the *computed* attributes of the resource as discreet outputs.
This kind of pattern protects against provider schema changes and is known as an [anti-corruption layer](https://learn.microsoft.com/en-us/azure/architecture/patterns/anti-corruption-layer).

Remember, you **SHOULD NOT** output values that are already inputs (other than `name`).

E.g.,

```terraform
# Resource output, computed attribute.
output "foo" {
  description = "MyResource foo attribute"
  value = azurerm_resource_myresource.foo
}

# Resource output for resources that are deployed using `for_each`. Again only computed attributes.
output "childresource_foos" {
  description = "MyResource children's foo attributes"
  value = {
    for key, value in azurerm_resource_mychildresource : key => value.foo
  }
}

# Output of a sensitive attribute
output "bar" {
  description = "MyResource bar attribute"
  value     = azurerm_resource_myresource.bar
  sensitive = true
}
```
