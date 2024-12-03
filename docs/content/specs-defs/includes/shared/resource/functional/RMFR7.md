---
title: RMFR7 - Minimum Required Outputs
url: /spec/RMFR7
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 2080
---

#### ID: RMFR7 - Category: Outputs - Minimum Required Outputs

Module owners **MUST** output the following outputs as a minimum in their modules:

| Output                                                                 | Bicep Output Name             | Terraform Output Name             |
|------------------------------------------------------------------------|-------------------------------|-----------------------------------|
| Resource Name                                                          | `name`                        | `name`                            |
| Resource ID                                                            | `resourceId`                  | `resource_id`                     |
| System Assigned Managed Identity Principal ID (if supported by module) | `systemAssignedMIPrincipalId` | `system_assigned_mi_principal_id` |

{{< hint type=tip >}}

Module owners **MAY** also have to provide additional outputs depending on the IaC language, please check the language specific specs:

- [Bicep](/Azure-Verified-Modules/specs/bcp/)
- [Terraform](/Azure-Verified-Modules/specs/tf/)

{{< /hint >}}
