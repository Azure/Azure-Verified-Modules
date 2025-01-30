---
title: SFR1 - Preview Services
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SFR1
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 10
---

## ID: SFR1 - Category: Composition - Preview Services

Modules **MAY** create/adopt public preview services and features at their discretion.

Preview API versions **MAY** be used when:

- The resource/service/feature is GA but the only API version available for the GA resource/service/feature is a preview version
  - For example, Diagnostic Settings (`Microsoft.Insights/diagnosticSettings`) the latest version of the API available with GA features, like Category Groups etc., is `2021-05-01-preview`
  - Otherwise the latest "non-preview" version of the API **SHOULD** be used

Preview services and features, **SHOULD NOT** be promoted and exposed, unless they are supported by the respective PG, and it's documented publicly.

However, they **MAY** be exposed at the module owners discretion, but the following rules **MUST** be followed:

- The description of each of the parameters/variables used for the preview service/feature **MUST** start with:
  - *"THIS IS A <PARAMETER/VARIABLE> USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE PRODUCT DOCS FOR CLARIFICATION"*
