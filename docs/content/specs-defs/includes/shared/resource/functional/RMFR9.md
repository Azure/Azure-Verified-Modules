---
title: RMFR9 - End-of-life resource versions
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/RMFR9
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 2090
---

## ID: RMFR9 - Category: Composition - End-of-life resource versions

When a given version of an Azure resource used in a resource module reaches its end-of-life (EOL) and is no longer supported by Microsoft, the module owner **SHOULD** ensure that:

1. The module is aligned with these changes and only includes supported versions of the resource. This is typically achieved through the allowed values in the parameter that specifies the resource SKU or type.
2. The following notice is shown under the `Notes` section of the module's `readme.md`. (If any related public announcement is available, it can also be linked to from the Notes section.):
    > "Certain versions of this Azure resource reached their end of life. The latest version of this module only includes supported versions of the resource. All unsupported versions have been removed from the related parameters."
3. AND the related parameter's description:
    > "Certain versions of this Azure resource reached their end of life. The latest version of this module only includes supported versions of the resource. All unsupported versions have been removed from this parameter."
