---
title: TFNFR25 - Verified Modules Requirements
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR25
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-CodeStyle, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21250
---

## ID: TFNFR25 - Category: Code Style - Verified Modules Requirements

The `terraform.tf` file **MUST** only contain one `terraform` block.

The first line of the `terraform` block **MUST** define a `required_version` property for the Terraform CLI.

The `required_version` property **MUST** include a constraint on the minimum version of the Terraform CLI. Previous releases of the Terraform CLI can have unexpected behavior.

The `required_version` property **MUST** include a constraint on the maximum major version of the Terraform CLI. Major version releases of the Terraform CLI can introduce breaking changes and **MUST** be tested.

The `required_version` property constraint **SHOULD** use the `~> #.#` or the `>= #.#.#, < #.#.#` format.

***Note: You can read more about Terraform version constraints in the [documentation](https://developer.hashicorp.com/terraform/language/expressions/version-constraints).***

Example `terraform.tf` file:

```terraform
terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.11"
    }
  }
}
```
