---
title: SNFR3 - AVM Compliance Tests
url: /spec/SNFR3
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Telemetry, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1040
---

#### ID: SNFR3 - Category: Testing - AVM Compliance Tests

Modules **MUST** pass all tests that ensure compliance to AVM specifications. These tests **MUST** pass before a module version can be published.

{{% notice style="important" %}}

Please note these are still under development at this time and will be published and available soon for module owners.

Module owners **MUST** request a manual GitHub Pull Request review, prior to their first release of version `0.1.0` of their module, from the related GitHub Team: [`@Azure/avm-core-team-technical-bicep`](https://github.com/orgs/Azure/teams/avm-core-team-technical-bicep), OR [`@Azure/avm-core-team-technical-terraform`](https://github.com/orgs/Azure/teams/avm-core-team-technical-terraform).

{{% /notice %}}
