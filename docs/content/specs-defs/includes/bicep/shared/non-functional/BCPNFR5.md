---
title: BCPNFR5 - Role Assignments Role Definition Mapping Limits
url: /spec/BCPNFR5
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-SHOULD, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11060
---

#### ID: BCPNFR5 - Category: Composition - Role Assignments Role Definition Mapping Limits

As per [BCPFR2](/Azure-Verified-Modules/spec/BCPFR2), module owners **MAY** define common RBAC Role Definition names and IDs within a variable to allow consumers to define a RBAC Role Definition by their name rather than their ID.

Module owners **SHOULD NOT** map every RBAC Role Definition within this variable as it can cause the module to bloat in size and cause consumption issues later when stitched together with other modules due to the 4MB ARM Template size limit.

Therefore module owners **SHOULD** only map the most applicable and common RBAC Role Definition names for their module and **SHOULD NOT** exceed 15 RBAC Role Definitions in the variable.

{{< hint type=important >}}

Remember if the RBAC Role Definition name is not included in the variable this does not mean it cannot be declared, used and assigned to an identity via an RBAC Role Assignment as part of a module, as any RBAC Role Definition can be specified via its ID without being in the variable.

{{< /hint >}}

{{< hint type=tip >}}

Review the [Bicep Contribution Guide's 'RBAC Role Definition Name Mapping' section](/Azure-Verified-Modules/contributing/bicep/#rbac-role-definition-name-mapping) for a code sample to achieve this requirement.

{{< /hint >}}
