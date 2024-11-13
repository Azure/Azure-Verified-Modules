---
title: RMFR7 - Minimum Required Outputs
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Type-Functional,
  Category-Outputs,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
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

- [Bicep](/Azure-Verified-Modules/specs/bicep/)
- [Terraform](/Azure-Verified-Modules/specs/terraform/)

{{< /hint >}}
