---
title: SFR4 - Telemetry Enablement Flexibility
url: /spec/SFR4
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Telemetry, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 40
---

#### ID: SFR4 - Category: Telemetry - Telemetry Enablement Flexibility

The telemetry enablement **MUST** be on/enabled by default, however this **MUST** be able to be disabled by a module consumer by setting the below parameter/variable value to `false`:

- Bicep: `enableTelemetry`
- Terraform: `enable_telemetry`

{{< hint type=note >}}

Whenever a module references AVM modules that implement the telemetry parameter (e.g., a pattern module that uses AVM resource modules), the telemetry parameter value **MUST** be passed through to these modules. This is necessary to ensure a consumer can reliably enable & disable the telemetry feature for all used modules.

{{< /hint >}}
