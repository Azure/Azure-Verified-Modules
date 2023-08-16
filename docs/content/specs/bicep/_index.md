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

## Functional Requirements

## Non-Functional Requirements

### ID: BCPNFR1 - Category: Composition - Cross-Referencing Modules

Module owners **MAY** cross-references other modules to build either Resource or Pattern modules.

However, they **MUST** be referenced only by a public registry reference to a pinned version e.g. `br/public:avm/xxx/yyy:1.2.3`. They **MUST NOT** use local parent path references to a module e.g. `../../xxx/yyy.bicep`.

Although, child modules, that are children of the primary resources being deployed by the AVM Resource Module, **MAY** be specified via local child path e.g. `child/resource.bicep`.

### ID: BCPNFR2 - Category: Inputs - Data Types

To simplify the consumption experience for module consumers when interacting with complex data types input parameters, mainly objects and arrays, the Bicep feature of [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) **MUST** be used and declared.

{{< hint type=note >}}

The AVM team are aware that to use [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) at this time, August 2023, you must [enable the preview feature via the `bicepconfig.json`](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types#enable-the-preview-feature).

This is only planned to be temporary and will be made part of the default features enabled in a upcoming release of Bicep very soon.

{{< /hint >}}

[User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) allow intellisense support in supported IDEs (e.g. Visual Studio Code) for complex input parameters using arrays and objects.

{{< hint type=important title="CARML Migration Exemption" >}}

A early goal for AVM is to complete the [evolution/migration of CARML](/Azure-Verified-Modules/faq/#carml-evolution) modules into AVM modules so they are available on the Bicep Public Registry. However, retrofitting [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) for all CARML modules as they come into AVM will take a considerable amount of time.

Therefore it has been decided by the AVM core team that CARML modules initial migrations to AVM will **NOT** mandate and enforce the addition of using and defining [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types). However, all CARML migrated modules to AVM **MUST** add [User-Defined Types](https://learn.microsoft.com/azure/azure-resource-manager/bicep/user-defined-data-types) prior to their next release of a version of the module.

{{< /hint >}}
