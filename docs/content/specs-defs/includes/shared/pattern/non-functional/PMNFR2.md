---
title: PMNFR2 - Use Resource Modules to Build a Pattern Module
url: /spec/PMNFR2
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 4030
---

#### ID: PMNFR2 - Category: Composition - Use Resource Modules to Build a Pattern Module

A Pattern Module **SHOULD** be built from AVM Resources Modules to establish a standardized code base and improve maintainability. If a valid reason exists, a pattern module **MAY** contain native resources ("vanilla" code) where it's necessary. A Pattern Module **MUST NOT** contain references to non-AVM modules.

Valid reasons for not using a Resource Module for a resource required by a Pattern Module include but are not limited to:

- When using a Resource Module would result in hitting scaling limitations and/or would reduce the capabilities of the Pattern Module due to the limitations of Azure Resource Manager.
- Developing a Pattern Module under time constraint, without having all required Resource Modules readily available.

{{< hint type=note >}}
In the latter case, the Pattern Module **SHOULD** be updated to use the Resource Module when the required Resource Module becomes available, to avoid accumulating technical debt. Ideally, all required Resource Modules **SHOULD** be developed first, and then leveraged by the Pattern Module.
{{< /hint >}}
