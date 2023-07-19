---
title: Shared Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< hint type=tip >}}

Make sure to checkout the [Module Classification Definitions](/Azure-Verified-Modules/specs/shared/module-classifications/) first before reading further so you understand the difference between a Resource and Pattern Module in AVM.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

{{< toc >}}
## Shared Requirements

Listed below are both functional and non-functional requirements for both classifications of AVM modules (Resource and Pattern)

### Functional Requirements

#### ID: SFR1 - Category: Composition

Modules **MAY** create/adopt public preview services and features at their discretion.

### Non-Functional Requirements

#### ID: SNFR1 - Category: Testing

Modules **MUST** use the prescribed tooling and testing frameworks defined in the language specific specs.

#### ID: SNFR2 - Category: Testing

Modules **MUST** implement end-to-end (deployment) testing.

#### ID: SNFR3 - Category: Testing

Modules **MUST** implement implement AVM unit tests that ensure compliance to AVM specifications.

#### ID: SNFR4 - Category: Testing

Modules **SHOULD** implement unit testing to ensure logic and conditions within variables/locals are performing correctly.

#### ID: SNFR5 - Category: Testing

Modules **SHOULD** implement upgrade testing to ensure new features are implemented in a non-breaking fashion on mom-major releases.

#### ID: SNFR6 - Category: Testing

Modules **MUST** use static analysis, e.g., linting, security scanning.

#### ID: SNFR7 - Category: Testing

Modules **MUST** implement idempotency end-to-end (deployment) testing. E.g. deploying the module twice over the top of itself.

#### ID: SNFR8 - Category: Contribution/Support

A module **MUST** have an owner that is defined and managed by a GitHub Team in the Azure GitHub organization.

Today this is only Microsoft FTEs, but everyone is welcome to contribute. The module just **MUST** be owned by a Microsoft FTE (today) so we can enforce and provide the long-term support required by this initiative.

#### ID: SNFR9 - Category: Contribution/Support

A module **MUST** make the following GitHub Teams in the Azure GitHub organization admins on its GitHub repo:

- [`@Azure/avm-core-team`](https://github.com/orgs/Azure/teams/avm-core-team/members?query=membership:child-team) = AVM Core Team
- [`@Azure/terraform-azure`](https://github.com/orgs/Azure/teams/terraform-azure) = Terraform PG
- `TBC` = Bicep PG team

#### ID: SNFR10 - Category: Contribution/Support

A module **MUST** be published with the MIT License in the Azure GitHub organization.

#### ID: SNFR11 - Category: Contribution/Support

A module owner **MUST** respond to logged issues within 3 business days.

#### ID: SNFR12 - Category: Contribution/Support

Only the latest released version of a module **MUST** be supported.

For example, if an AVM Resource Module is used in an AVM Pattern Module that was working but now is not. The first step by the AVM Pattern Module owner should be to upgrade to the latest version of the AVM Resource Module test and then if not fixed, troubleshoot and fix forward from the that latest version of the AVM Resource Module onwards.

This avoids AVM Module owners from having to maintain multiple major release versions.

#### ID: SNFR13 - Category: Forking

A module **MUST** also function within a private module registry, internal Git repo.

#### ID: SNFR14 - Category: Inputs

A module **SHOULD** use either: simple data types. e.g., string, int, bool.

OR

Complex data types (objects, arrays, maps) when the schema is defined and supported by the IDE.

#### ID: SNFR15 - Category: Documentation

README documentation **MUST** be automatically/programmatically generated. **MUST** include inputs, outputs, resources deployed.

#### ID: SNFR16 - Category: Documentation

An examples directory **MUST** exist to provide named scenarios for module deployment.

#### ID: SNFR17 - Category: Release

Modules **MUST** use semantic versioning (aka semver) for their versions and releases in accordance with: [Semantic Versioning 2.0.0](https://semver.org/)


#### ID: SNFR18 - Category: Release

A module **SHOULD** avoid breaking changes, e.g., deprecating inputs vs. removing.

#### ID: SNFR19 - Category: Publishing

Modules **MUST** be published to their respective language public registries.

- Terraform = [HashiCorp Terraform Registry](https://registry.terraform.io/)
- Bicep = [Bicep Public Module Registry](https://github.com/Azure/bicep-registry-modules/tree/main)
  - Within the `avm` directory

#### ID: SNFR20 - Category: Publishing

Modules **MUST** be published to their respective language public registries.


## Resource Module Requirements

Listed below are both functional and non-functional requirements for [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements

#### ID: RMFR1 - Category: Composition

A module **MUST** only deploy a single instance of the primary resource, e.g., one virtual machine per instance.

Multiple instances of the module **MUST** be used to scale out.

#### ID: RMFR2 - Category: Composition

A module **MUST** add value by including additional features on top of the primary resource. For example a module to create a Resource Group adds little value and therefore should not be created as a Resource Module as explained in RMFR3

#### ID: RMFR3 - Category: Composition

A module **MUST NOT** create a Resource Group **for resources that require them.**

In the case that a Resource Group is required, a module **MUST** have an input (scope or variable):

- In Bicep the `targetScope` **MUST** be set to `resourceGroup` or not specified (which means default to `resourceGroup` scope)
- In Terraform the `variable` **MUST** be called `resource_group`

Scopes will be covered further in the respective language specific specifications.

#### ID: RMFR4 - Category: Composition

Modules **MUST** support the following optional features/extension resources, if supported by the primary resource. The top-level variable/parameter names **MUST** be:

| Optional Features/Extension Resources       | Bicep Parameter Name  | Terraform Variable Name |
| ------------------------------------------- | --------------------- | ----------------------- |
| Diagnostic Settings                         | `diagnosticSettings`  | `diagnostic_settings`   |
| Role Assignments                            | `roleAssignments`     | `role_assignments`      |
| Resource Locks                              | `locks`               | `locks`                 |
| Tags                                        | `tags`                | `tags`                  |
| Azure Monitor Alerts                        | `alerts`              | `alerts`                |
| Private Endpoints                           | `privateEndpoints`    | `private_endpoints`     |
| Customer Managed Keys                       | `customerManagedKeys` | `customer_managed_keys` |
| Managed Identities (System / User Assigned) | `managedIdentites`    | `managed_identites`     |

Module owners **MAY** choose to utilize cross repo dependencies for these "add-on" resources, or **MAY** chose to implement the code directly in their own repo/module. So long as the implementation and outputs are as per the specifications requirements, then this is acceptable.

#### ID: RMFR5 - Category: Composition

Modules **SHOULD** implement a common interface, e.g. the input's data structures and properties within them (objects/arrays/dictionaries/maps), for the optional features/extension resources:

See:

- [Diagnostic Settings Interface](/Azure-Verified-Modules/specs/shared/)
- [Role Assignments Interface](/Azure-Verified-Modules/specs/shared/)
- [Resource Locks Interface](/Azure-Verified-Modules/specs/shared/)
- [Tags Interface](/Azure-Verified-Modules/specs/shared/)
- [Alerts Interface](/Azure-Verified-Modules/specs/shared/)
- [Private Endpoints Interface](/Azure-Verified-Modules/specs/shared/)
- [Customer Managed Keys Interface](/Azure-Verified-Modules/specs/shared/)
- [Managed Identities Interface](/Azure-Verified-Modules/specs/shared/)

#### ID: RMFR6 - Category: Inputs

Parameters/variables that pertain to the primary resource **MUST NOT** use the resource type in the name.

e.g., use `sku`, vs. `virtualMachineSku`/`virtualmachine_sku`

Another example for where RPs contain some of their name within a property, leave the property unchanged. E.g. Key Vault has a property called `keySize`, it is fine to leave as this and not remove the `key` part from the property/parameter name.

#### ID: RMFR7 - Category: Availability

Modules SHOULD use Availability Zones by default.

### Non-Functional Requirements

#### ID: RMNFR1 - Category: Naming

Module names **MUST** follow the following pattern (all lower case):

- Terraform: `terraform-<provider>-avm-res-<rp>-<armresourcename>`
- Bicep: `avm-res-<rp>-<armresourcename>` (to support registry hosting)

Example: `avm-res-compute-virtualmachine`

- `<armresourcename>` is the singular version of the word after the resource provider, e.g., `Microsoft.Compute/virtualMachines` = `virtualmachine`
- `<rp>` is the provider’s name after the `Microsoft` part, e.g., `Microsoft.Compute` = `compute`.
- `res` defines this is a resource module

{{< hint type=note >}}

We will maintain a JSON file in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/issues) with the correct singular names for all resource types to enable checks to utilize this list to ensure repos are named correctly.

This will be updated quarterly, or ad-hoc as new RPs/ Resources are created and highlighted via a check failure.

{{< /hint >}}

#### ID: RMNFR2 - Category: Inputs

A module **SHOULD** use the following standard inputs:

- `name` (no default)
- `location` (use Resource Group location, if resource supports Resource Groups, otherwise no default)

## Pattern Module Requirements

Listed below are both functional and non-functional requirements for [AVM Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements

#### ID: PMFR1 - Category: Composition

A module **MAY** create Resource Group(s).

### Non-Functional Requirements

#### ID: PMNFR1 - Category: Naming

Module names **MUST** follow the following pattern (all lower case):

- Terraform: `terraform-<provider>-avm-ptn-<patternmodulename>`
- Bicep: `avm-ptn-<patternmodulename>`

Example: `avm-ptn-apptiervmss`

- `<patternmodulename>` is a term describing the module’s function, e.g., `apptiervmss` = Application Tier VMSS
- `ptn` defines this as a pattern module

#### ID: PMNFR2 - Category: Composition

A module **SHOULD** be built from the required AVM Resources Modules

#### ID: PMNFR3 - Category: Composition

A module **MAY** contain and be built using other AVM Pattern Modules

#### ID: PMNFR4 - Category: Hygiene

An item **MUST** be logged onto as an issue on the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/issues) if a Resource Module does not exist for resources deployed by the pattern module.

{{< hint type=important title=Exception >}}

If the Resource Module adds no value, see Resource Module functional requirement [ID: RMFR2](#id-rmfr2---category-composition)

{{< /hint >}}

#### ID: PMNFR5 - Category: Inputs

Parameter/variable input names **SHOULD** contain the resource to which they pertain. E.g., `virtualMachineSku`/`virtualmachine_sku`
