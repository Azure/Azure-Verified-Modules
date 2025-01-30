---
title: TFNFR5 - Test Tooling
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFNFR5
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Testing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 21050
---

## ID: TFNFR5 - Category: Testing - Test Tooling

Module owners **MUST** use the below tooling for unit/linting/static/security analysis tests. These are also used in the AVM Compliance Tests.

- [Terraform](https://www.terraform.io/)
  - `terraform <validate/fmt/test>`
- [terrafmt](https://github.com/katbyte/terrafmt)
- [Checkov](https://www.checkov.io/)
- [tflint (with azurerm ruleset)](https://github.com/terraform-linters/tflint-ruleset-azurerm)
- [Go](https://go.dev/)
  - Some tests are provided as part of the AVM Compliance Tests, but you are free to also use Go for your own tests.
