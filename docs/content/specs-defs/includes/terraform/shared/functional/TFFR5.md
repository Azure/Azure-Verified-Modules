---
title: TFFR5 - AzAPI - replace_triggers_refs
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR5
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TF/CI/Enforced # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 20050
---

## ID: TFFR5 - Category: Composition - AzAPI - replace_triggers_refs

Authors **MUST** specify the `replace_triggers_refs` argument when using the AzAPI provider. The values should contain the body paths that would cause the resource to be replaced when they change.

This is to ensure that changes to properties that require replacement of the resource are handled correctly by Terraform.

```terraform
resource "azapi_resource" "example" {
  type      = "Microsoft.Example/resourceType@2021-01-01"
  name      = "example-resource"
  location  = "West US"
  replace_triggers_refs = [
    "properties.exampleProperty"
  ] # must be specified, even if empty
  body = {
    properties = {
      exampleProperty = "exampleValue"
    }
  }
}
