---
title: TFFR4 - AzAPI - response_export_values
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR4
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
priority: 20040
---

## ID: TFFR4 - Category: Composition - AzAPI - response_export_values

Authors **MUST** specify the `response_export_values` argument when using the AzAPI provider:

```terraform
resource "azapi_resource" "example" {
  type      = "Microsoft.Example/resourceType@2021-01-01"
  name      = "example-resource"
  location  = "West US"
  response_export_values = [] # must be specified, even if empty
  body = {
    properties = {
      exampleProperty = "exampleValue"
    }
  }
}

If you require read-only properties to be returned from the resource, you SHOULD include them as follows:

```terraform
resource "azapi_resource" "example" {
  type      = "Microsoft.Example/resourceType@2021-01-01"
  name      = "example-resource"
  location  = "West US"
  # Example as a list:
  response_export_values = ["properties.readOnlyProperty"]
  # Example as a map:
  # response_export_values = {
  #   read_only_property = "properties.readOnlyProperty"
  # }
  body = {
    properties = {
      exampleProperty = "exampleValue"
    }
  }
}

output "read_only_property" {
  # Example if response_export_values is a list:
  value = azapi_resource.example.output.properties.readOnlyProperty
  # Example if response_export_values is a map:
  # value = azapi_resource.example.output.read_only_property
}
```
