---
title: BCPNFR2 - Module Documentation Generation
url: /spec/BCPNFR2
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Documentation, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11030
---

#### ID: BCPNFR2 - Category: Documentation - Module Documentation Generation

{{% notice style="note" %}}

This script/tool is currently being developed by the AVM team and will be made available very soon.

{{% /notice %}}

Bicep modules documentation **MUST** be automatically generated via the provided script/tooling from the AVM team, providing the following headings:

- Title
- Description
- Navigation
- Resource Types
- Usage Examples
- Parameters
- Outputs
- Cross-referenced modules
