---
title: BCPNFR6 - Role Assignments Role Definition Mapping Compulsory Roles
url: /spec/BCPNFR6
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Composition,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-Maintenance
]
priority: 11070
---

#### ID: BCPNFR6 - Category: Composition - Role Assignments Role Definition Mapping Compulsory Roles

Module owners **MUST** include the following roles in the variable for RBAC Role Definition names:

- Owner - ID: `8e3af657-a8ff-443c-a75c-2fe8c4bcb635`
- Contributor - ID: `b24988ac-6180-42a0-ab88-20f7382dd24c`
- Reader - ID: `acdd72a7-3385-48ef-bd42-f606fba81ae7`
- User Access Administrator - ID: `18d7d88d-d35e-4fb5-a5c3-7773c20a72d9`
- Role Based Access Control Administrator (Preview) - ID: `f58310d9-a9f6-439a-9e8d-f62e7b41a168`

{{< hint type=tip >}}

Review the [Bicep Contribution Guide's 'RBAC Role Definition Name Mapping' section](/Azure-Verified-Modules/contributing/bicep/#rbac-role-definition-name-mapping) for a code sample to achieve this requirement.

{{< /hint >}}
