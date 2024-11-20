---
title: RMFR5 - AVM Consistent Feature & Extension Resources Value Add Interfaces/Schemas
url: /spec/RMFR5
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 2050
---

#### ID: RMFR5 - Category: Composition - AVM Consistent Feature & Extension Resources Value Add Interfaces/Schemas

Resource modules **MUST** implement a common interface, e.g. the input's data structures and properties within them (objects/arrays/dictionaries/maps), for the optional features/extension resources:

See:

- [Diagnostic Settings Interface](/Azure-Verified-Modules/specs/shared/interfaces/#diagnostic-settings)
- [Role Assignments Interface](/Azure-Verified-Modules/specs/shared/interfaces/#role-assignments)
- [Resource Locks Interface](/Azure-Verified-Modules/specs/shared/interfaces/#resource-locks)
- [Tags Interface](/Azure-Verified-Modules/specs/shared/interfaces/#tags)
- [Managed Identities Interface](/Azure-Verified-Modules/specs/shared/interfaces/#managed-identities)
- [Private Endpoints Interface](/Azure-Verified-Modules/specs/shared/interfaces/#private-endpoints)
- [Customer Managed Keys Interface](/Azure-Verified-Modules/specs/shared/interfaces/#customer-managed-keys)
- [Alerts Interface](/Azure-Verified-Modules/specs/shared/interfaces/#azure-monitor-alerts)
