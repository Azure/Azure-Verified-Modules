---
title: BCPNFR20 - User-defined types - Export
url: /spec/BCPNFR20
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

#### ID: BCPNFR20 - User-defined types - Export

User-defined types (UDTs) SHOULD always be exported via the `@export()` annotation in every template they're implemented in.
```bicep
@export()
type subnetType = { ... }
```

Doing so has the benefit that other (e.g., parent) modules can import them and as such reduce code duplication. Also, if the module itself is published, users of the Public Bicep Registry can import the types independently of the module itself. One example where this can be useful is a pattern module that may re-use the same interface when referencing a module from the registry.
