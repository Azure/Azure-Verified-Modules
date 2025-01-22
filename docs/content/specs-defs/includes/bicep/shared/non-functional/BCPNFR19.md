---
title: BCPNFR19 - User-defined types - Naming
url: /spec/BCPNFR18
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 11010
---

#### ID: BCPNFR19 - User-defined types - Naming

User-defined types (UDTs) MUST always end with the suffix `(...)Type` to make them obvious to users. In addition it is recommended to extend the suffix to `(...)OutputType` if a UDT is exclusively used for outputs.
```bicep
type subnet = { ... } // Wrong
type subnetType = { ... } // Correct
type subnetOutputType = { ... } // Correct, if used only for outputs
```

Since User-defined types (UDTs) MUST always be singular as per [BCPNFR18]({{% siteparam base %}}/spec/BCPNFR18), their naming should reflect this and also be singular.
```bicep
type subnetsType = { ... } // Wrong
type subnetType = { ... } // Correct
```
