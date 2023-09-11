---
title: Bicep Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< hint type=tip >}}

Make sure to checkout the [Shared Specification](/Azure-Verified-Modules/specs/shared/) first before reading further so you understand the specifications items that are shared and agnostic to the IaC language/tool.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

{{< toc >}}

## Shared Requirements (Resource & Pattern Modules)

### Functional Requirements

#### ID: BCPFR1 - Category: Composition - Cross-Referencing Modules

Module owners **MAY** cross-references other modules to build either Resource or Pattern modules.

However, they **MUST** be referenced only by a public registry reference to a pinned version e.g. `br/public:avm/xxx/yyy:1.2.3`. They **MUST NOT** use local parent path references to a module e.g. `../../xxx/yyy.bicep`.

Although, child modules, that are children of the primary resources being deployed by the AVM Resource Module, **MAY** be specified via local child path e.g. `child/resource.bicep`.

#### ID: BCPFR2 - Category: Composition - Role Assignments Role Definition Mapping

Module owners **MAY** define common RBAC Role Definition names and IDs within a variable to allow consumers to define a RBAC Role Definition by their name rather than their ID, this should be self contained within the module themselves.

However, the **MUST** use only the official RBAC Role Definition name within the variable and nothing else.

See also:

- [BCPNFR5](#id-bcpnfr5---category-composition---role-assignments-role-definition-mapping-limits)
- [BCPNFR6](#id-bcpnfr6---category-composition---role-assignments-role-definition-mapping-compulsory-roles)

{{< hint type=tip >}}

Review the [Bicep Contribution Guide's 'RBAC Role Definition Name Mapping' section](/Azure-Verified-Modules/contributing/bicep/#rbac-role-definition-name-mapping) for a code sample to achieve this requirement.

{{< /hint >}}

### Non-Functional Requirements

#### ID: BCPNFR1 - Category: Inputs - Data Types

To simplify the consumption experience for module consumers when interacting with complex data types input parameters, mainly objects and arrays, the Bicep feature of [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) **MUST** be used and declared.

{{< hint type=tip >}}

User-Defined Types are GA in Bicep as of version v0.21.1, please ensure you have this version installed as a minimum.

{{< /hint >}}

[User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) allow intellisense support in supported IDEs (e.g. Visual Studio Code) for complex input parameters using arrays and objects.

{{< hint type=important title="CARML Migration Exemption" >}}

A early goal for AVM is to complete the [evolution/migration of CARML](/Azure-Verified-Modules/faq/#carml-evolution) modules into AVM modules so they are available on the Bicep Public Registry. However, retrofitting [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) for all CARML modules as they come into AVM will take a considerable amount of time.

Therefore it has been decided by the AVM core team that CARML modules initial migrations to AVM will **NOT** mandate and enforce the addition of using and defining [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types). However, all CARML migrated modules to AVM **MUST** add [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) prior to their next release of a version of the module.

{{< /hint >}}

#### ID: BCPNFR2 - Category: Documentation - Module Documentation Generation

{{< hint type=note >}}

This script/tool is currently being developed by the AVM team and will be made available very soon.

{{< /hint >}}

Bicep modules documentation **MUST** be automatically generated via the provided script/tooling from the AVM team.

#### ID: BCPNFR3 - Category: Documentation - Parameter Files

Bicep modules **MUST** provide parameter files in the following formats:

- JSON / ARM Template Parameter Files - `.json`
- Bicep file (orchestration module style) - `.bicep`

{{< hint type=note >}}

Bicep Parameter Files (`.bicepparam`) are being reviewed and considered by the AVM team for the usability and features at this time and will likely be added in the future.

{{< /hint >}}

#### ID: BCPNFR4 - Category: Documentation - Parameter Input Examples

Bicep modules **MUST** provide parameter input examples for each parameter using the `metadata.example` property via the `@metadata()` decorator.

Example:

```bicep
@metadata({
  example: 'uksouth'
})
@description('Optional. Location for all resources.')
param location string = resourceGroup().location
```

#### ID: BCPNFR5 - Category: Composition - Role Assignments Role Definition Mapping Limits

As per [BCPFR2](#id-bcpfr2---category-composition---role-assignments-role-definition-mapping), module owners **MAY** define common RBAC Role Definition names and IDs within a variable to allow consumers to define a RBAC Role Definition by their name rather than their ID.

Module owners **SHOULD NOT** map every RBAC Role Definition within this variable as it can cause the module to bloat in size and cause consumption issues later when stitched together with other modules due to the 4MB ARM Template size limit.

Therefore modules owners **SHOULD** only map the most applicable and common RBAC Role Definition names for their module and **SHOULD NOT** exceed 15 RBAC Role Definitions in the variable.

{{< hint type=important >}}

Remember if the RBAC Role Definition name is not included in the variable this does not mean it cannot be declared, used and assigned to an identity via an RBAC Role Assignment as part of a module, as any RBAC Role Definition can be specified via its ID without being in the variable.

{{< /hint >}}

{{< hint type=tip >}}

Review the [Bicep Contribution Guide's 'RBAC Role Definition Name Mapping' section](/Azure-Verified-Modules/contributing/bicep/#rbac-role-definition-name-mapping) for a code sample to achieve this requirement.

{{< /hint >}}


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
