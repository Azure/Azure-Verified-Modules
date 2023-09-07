---
title: Shared Specification (Bicep & Terraform)
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

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for both classifications of AVM modules (Resource and Pattern)

### Functional Requirements

#### ID: SFR1 - Category: Composition - Preview Services

Modules **MAY** create/adopt public preview services and features at their discretion.

Preview API versions **MAY** be used when:

- The resource/service/feature is GA but the only API version available for the GA resource/service/feature is a preview version
  - For example, Diagnostic Settings (`Microsoft.Insights/diagnosticSettings`) the latest version of the API available with GA features, like Category Groups etc., is `2021-05-01-preview`
  - Otherwise the latest "non-preview" version of the API **SHOULD** be used

Preview services and features, **SHOULD NOT** be promoted and exposed, unless they are supported by the respective PG, and it's documented publicly.

However, they **MAY** be exposed at the module owners discretion, but the following rules **MUST** be followed:

- The description of each of the parameters/variables used for the preview service/feature **MUST** start with:
  - *"THIS IS A <PARAMETER/VARIABLE> USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE PRODUCT DOCS FOR CLARIFICATION"*

#### ID: SFR2 - Category: Composition - WAF Aligned

Modules **SHOULD** align to Well-Architected Framework (WAF) pillar recommendations, alongside Microsoft Cloud Security Benchmark (MCSB) and Microsoft Defender for Cloud (MDFC), where appropriate and applicable.

They **SHOULD NOT** align to these recommendations when it requires an external dependency/resource to be deployed and configured and then associated to the resources in the module.

Alignment **SHOULD** prioritize best-practices and security over cost optimization, but **MUST** allow for these to be overridden by a module consumer easily, if desired.

{{< hint type=tip >}}

Read the FAQ of [What does AVM mean by “WAF Aligned”?](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned) for more information and examples.

{{< /hint >}}

#### ID: SFR3 - Category: Telemetry - Deployment/Usage Telemetry

Modules **MUST** provide the capability to collect deployment/usage telemetry, via a blank ARM deployment, as detailed in [Telemetry](/Azure-Verified-Modules/help-support/telemetry/) further.

The ARM deployment name used for the telemetry **MUST** follow the pattern and **MUST** be no longer than 64 characters in length: `<AVM 8 chars (alphanumeric)>.<res/ptn>.<module name>.<version>.<uniqueness>`

- `<AVM 8 chars (alphanumeric)>`
  - Bicep == `46d3xbcp`
  - Terraform == `46d3xgtf`
- `<res/ptn>` == AVM Resource or Pattern Module
- `<module name>` == The AVM Module's name **without**;
  - The prefixes: `avm-res-` or `terraform-<provider>-avm-res-` - See [RMNFR1](#id-rmnfr1---category-naming---module-naming) for AVM Resource Module Naming
  - The prefixes: `avm-ptn-` or `terraform-<provider>-avm-ptn-` - See [PMNFR1](#id-pmnfr1---category-naming---module-naming) for AVM Pattern Module Naming
    {{< hint type=note >}}

Due to the 64-character length limit of Azure deployment names, the `<module name>` segment has a length limit of 30 characters, so if the module name is longer than that, it **MUST** be truncated to 30 characters. If any of the semantic version's segments are longer than 1 character, it further restricts the number of characters that can be used for naming the module.

    {{< /hint >}}

- `<version>` == The AVM Module's version with `.` (periods) replaced with `-` (hyphens), to allow simpler splitting of the ARM deployment name
- `<uniqueness>` == This section of the ARM deployment name is to be used to ensure uniqueness of the deployment name.
  - This is to cater for the following scenarios:
    - The module is deployed multiple times to the same:
      - Location/Region
      - Scope (Tenant, Management Group,Subscription, Resource Group)

An example deployment name for the AVM Virtual Machine Resource Module would be:
- Bicep == `46d3xbcp.res.compute-virtualmachine.v1-2-3.eum3`
- Terraform == `46d3xtf.res.compute-virtualmachine.v1-2-3.eum3`

{{< hint type=tip >}}

See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep](/Azure-Verified-Modules/contributing/bicep/)
- [Terraform](/Azure-Verified-Modules/contributing/terraform/)


{{< /hint >}}

#### ID: SFR4 - Category: Telemetry - Telemetry Enablement Flexibility

The telemetry enablement **MUST** be on/enabled by default, however this **MUST** be able to be disabled by a module consumer by setting the below parameter/variable value to `false`:

- Bicep: `enableDefaultTelemetry`
- Terraform: `enable_default_telemetry`

#### ID: SFR5 - Category: Composition - Availability Zones

Modules that deploy ***zone-redundant*** resources **MUST** enable the spanning across as many zones as possible by default, typically all 3.

Modules that deploy ***zonal*** resources **MUST** provide the ability to specify a zone for the resources to be deployed/pinned to. However, they **MUST NOT** default to a particular zone by default, e.g. `1` in an effort to make the consumer aware of the zone they are selecting to suit their architecture requirements.

For both scenarios the modules **MUST** expose these configuration options via configurable parameters/variables.

{{< hint type=note >}}

For information on the differences between zonal and zone-redundant services, see [Availability zone service and regional support](https://learn.microsoft.com/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support)

{{< /hint >}}

#### ID: SFR6 - Category: Composition - Data Redundancy

Modules that deploy resources or patterns that support data redundancy **SHOULD** enable this to the highest possible value by default, e.g. `RA-GZRS`. When a resource or pattern doesn't provide the ability to specify data redundancy as a simple property, e.g. `GRS` etc., then the modules **MUST** provide the ability to enable data redundancy for the resources or pattern via parameters/variables.

For example, a Storage Account module can simply set the `sku.name` property to `Standard_RAGZRS`. Whereas a SQL DB or Cosmos DB module will need to expose more properties, via parameters/variables, to allow the specification of the regions to replicate data to as per the consumers requirements.

{{< hint type=note >}}

For information on the data redundancy options in Azure, see [Cross-region replication in Azure](https://learn.microsoft.com/azure/reliability/cross-region-replication-azure)

{{< /hint >}}

### Non-Functional Requirements

#### ID: SNFR1 - Category: Testing - Prescribed Tests

Modules **MUST** use the prescribed tooling and testing frameworks defined in the language specific specs.

#### ID: SNFR2 - Category: Testing - E2E Testing

Modules **MUST** implement end-to-end (deployment) testing.

#### ID: SNFR3 - Category: Testing - AVM Unit Tests

Modules **MUST** implement implement AVM unit tests that ensure compliance to AVM specifications.

#### ID: SNFR4 - Category: Testing - Additional Unit Tests

Modules **SHOULD** implement unit testing to ensure logic and conditions within variables/locals are performing correctly.

#### ID: SNFR5 - Category: Testing - Upgrade Tests

Modules **SHOULD** implement upgrade testing to ensure new features are implemented in a non-breaking fashion on mom-major releases.

#### ID: SNFR6 - Category: Testing - Static Analysis/Linting Tests

Modules **MUST** use static analysis, e.g., linting, security scanning.

#### ID: SNFR7 - Category: Testing - Idempotency Tests

Modules **MUST** implement idempotency end-to-end (deployment) testing. E.g. deploying the module twice over the top of itself.

#### ID: SNFR8 - Category: Contribution/Support - Module Owner/s GitHub

A module **MUST** have an owner that is defined and managed by a GitHub Team in the Azure GitHub organization.

Today this is only Microsoft FTEs, but everyone is welcome to contribute. The module just **MUST** be owned by a Microsoft FTE (today) so we can enforce and provide the long-term support required by this initiative.

#### ID: SNFR20 - Category: Contribution/Support - GitHub Teams Only

All GitHub repositories that AVM module are published from and hosted within **MUST** only assign GitHub repository permissions to GitHub teams only.

Each module **MUST** have a separate GitHub Teams assigned for module owners **AND** module contributors respectively. 

There **MUST NOT** be any GitHub repository permissions assigned to individual users.

The naming convention for the GitHub Teams **MUST** follow the below pattern:
- `@azure/<module name>-module-owners-<bicep/tf>` - to be assigned as the GitHub repository's `Module Owners` team
- `@azure/<module name>-module-contributors-<bicep/tf>` - to be assigned as the GitHub repository's `Module Contributors` team

Segments:

- `@azure` == the GitHub organization the AVM repository exists in
- `<module name>` == the AVM Module's name
  - See [RMNFR1](#id-rmnfr1---category-naming---module-naming) for AVM Resource Module Naming
  - See [PMNFR1](#id-pmnfr1---category-naming---module-naming) for AVM Pattern Module Naming
- `module-owners` or `module-contributors` == the role the GitHub Team is assigned to
- `<bicep/tf>` == the language the module is written in

Examples:

- `@azure/avm-res-compute-virtualmachine-module-owners-bicep`
- `@azure/avm-res-compute-virtualmachine-module-contributors-tf`

#### ID: SNFR9 - Category: Contribution/Support - AVM & PG Teams GitHub Repo Permissions

A module **MUST** make the following GitHub Teams in the Azure GitHub organization admins on its GitHub repo:

- [`@Azure/avm-core-team`](https://github.com/orgs/Azure/teams/avm-core-team/members?query=membership:child-team) = AVM Core Team
- [`@Azure/bicep-admins`](https://github.com/orgs/Azure/teams/bicep-admins) = Bicep PG team
- [`@Azure/terraform-azure`](https://github.com/orgs/Azure/teams/terraform-azure) = Terraform PG

#### ID: SNFR10 - Category: Contribution/Support - MIT Licensing

A module **MUST** be published with the MIT License in the Azure GitHub organization.

#### ID: SNFR11 - Category: Contribution/Support - Issues Response Times

A module owner **MUST** respond to logged issues within 3 business days. See [Module Support](/Azure-Verified-Modules/help-support/module-support/) for more information

#### ID: SNFR12 - Category: Contribution/Support - Versions Supported

Only the latest released version of a module **MUST** be supported.

For example, if an AVM Resource Module is used in an AVM Pattern Module that was working but now is not. The first step by the AVM Pattern Module owner should be to upgrade to the latest version of the AVM Resource Module test and then if not fixed, troubleshoot and fix forward from the that latest version of the AVM Resource Module onwards.

This avoids AVM Module owners from having to maintain multiple major release versions.

#### ID: SNFR23 - Category: Contribution/Support - GitHub Repo Labels

GitHub repositories where modules are held **MUST** use the below labels and **SHOULD** not use any additional labels:

{{< expand "AVM Standard GitHub Labels" "expand/collapse" >}}

These labels are available in a CSV file from [here](/Azure-Verified-Modules/governance/avm-standard-github-labels.csv)

{{< entireCsvToTable header=true csv="/static/governance/avm-standard-github-labels.csv" >}}

{{< /expand >}}

To help apply these to a module GitHub repository you can use the below PowerShell script:

{{< expand "Set-AvmGitHubLabels.ps1" "expand/collapse" >}}

For most scenario this is the command you'll need to call the below PowerShell script with, replacing the value for `RepositoryName`:

```powershell
Set-AvmGitHubLabels.ps1 -RepositoryName "Org/MyGitHubRepo" -CreateCsvLabelExports $false -NoUserPrompts $true
```

By default this script will only update and append labels on the repository specified. However, this can be changed by setting the parameter `-UpdateAndAddLabelsOnly` to `$false`, which will remove all the labels from the repository first and then apply the AVM labels from the CSV only.

Full Script:

These `Set-AvmGitHubLabels.ps1` can be downloaded from <a href="/Azure-Verified-Modules/scripts/Set-AvmGitHubLabels.ps1" download>here</a>.

{{< include file="/static/scripts/Set-AvmGitHubLabels.ps1" language="powershell" options="linenos=false" >}}

{{< /expand >}}
#### ID: SNFR13 - Category: Forking - Private Module Registry Support

A module **MUST** also function within a private module registry, internal Git repo.

#### ID: SNFR14 - Category: Inputs - Data Types

A module **SHOULD** use either: simple data types. e.g., string, int, bool.

OR

Complex data types (objects, arrays, maps) when the schema is defined and supported by the IDE.

#### ID: SNFR22 - Category: Inputs - Parameters/Variables for Resource IDs

A module parameter/variable that requires a full Azure Resource ID as an input value, e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}`, **MUST** contain `ResourceId/resource_id` in it's parameter/variable name to assist users in knowing what value to provide at a glance of the parameter/variable name.

Example for the property `workspaceId` for the Diagnostic Settings resource. In Bicep it's parameter name should be `workspaceResourceId` and the variable name in Terraform should be `workspace_resource_id`.

`workspaceId` is not descriptive enough and is ambiguous as to which ID is required to be input.

#### ID: SNFR15 - Category: Documentation - Automatic Documentation Generation

README documentation **MUST** be automatically/programmatically generated. **MUST** include inputs, outputs, resources deployed.

#### ID: SNFR16 - Category: Documentation - Examples

An examples directory **MUST** exist to provide named scenarios for module deployment.

#### ID: SNFR17 - Category: Release - Semantic Versioning

Modules **MUST** use semantic versioning (aka semver) for their versions and releases in accordance with: [Semantic Versioning 2.0.0](https://semver.org/)

For example all modules should be released using a semantic version that matches this pattern: `vX.Y.Z`

- `X` == Major Version
- `Y` == Minor Version
- `Z` == Patch Version

Initially modules should be released as `v0.1.0` and incremented via Minor and Patch versions only until the module owner is happy the module has been "road tested" and is now stable enough for it's first Major release of `v1.0.0`.

> Releasing as `v0.1.0` initially and only incrementing Minor and Patch versions allows the module owner to make breaking changes more easily and frequently as it's still not an official Major/Stable release 👍

#### ID: SNFR18 - Category: Release - Breaking Changes

A module **SHOULD** avoid breaking changes, e.g., deprecating inputs vs. removing.

#### ID: SNFR19 - Category: Publishing - Registries Targeted

Modules **MUST** be published to their respective language public registries.

- Bicep = [Bicep Public Module Registry](https://github.com/Azure/bicep-registry-modules/tree/main)
  - Within the `avm` directory
- Terraform = [HashiCorp Terraform Registry](https://registry.terraform.io/)

{{< hint type=tip >}}

See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep](/Azure-Verified-Modules/contributing/bicep/)
- [Terraform](/Azure-Verified-Modules/contributing/terraform/)

{{< /hint >}}

#### ID: SNFR21 - Category: Publishing - Cross Language Collaboration

When the module owners of the same Resource or Pattern AVM module are not the same individual or team for all languages, each languages team **SHOULD** collaborate with their sibling language team for the same module to ensure consistency where possible.

## Resource Module Requirements

Listed below are both functional and non-functional requirements for [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements

#### ID: RMFR1 - Category: Composition - Single Resource Only

A module **MUST** only deploy a single instance of the primary resource, e.g., one virtual machine per instance.

Multiple instances of the module **MUST** be used to scale out.

#### ID: RMFR2 - Category: Composition - No Resource Wrapper Modules

A module **MUST** add value by including additional features on top of the primary resource. For example a module to create a Resource Group adds little value and therefore should not be created as a Resource Module as explained in RMFR3

#### ID: RMFR3 - Category: Composition - Resource Groups

A module **MUST NOT** create a Resource Group **for resources that require them.**

In the case that a Resource Group is required, a module **MUST** have an input (scope or variable):

- In Bicep the `targetScope` **MUST** be set to `resourceGroup` or not specified (which means default to `resourceGroup` scope)
- In Terraform the `variable` **MUST** be called `resource_group`

Scopes will be covered further in the respective language specific specifications.

#### ID: RMFR4 - Category: Composition - AVM Consistent Feature & Extension Resources Value Add

Modules support the following optional features/extension resources, as specified, if supported by the primary resource. The top-level variable/parameter names **MUST** be:

| Optional Features/Extension Resources       | Bicep Parameter Name | Terraform Variable Name | MUST/SHOULD |
| ------------------------------------------- | -------------------- | ----------------------- | ----------- |
| Diagnostic Settings                         | `diagnosticSettings` | `diagnostic_settings`   | MUST        |
| Role Assignments                            | `roleAssignments`    | `role_assignments`      | MUST        |
| Resource Locks                              | `lock`               | `lock`                  | MUST        |
| Tags                                        | `tags`               | `tags`                  | MUST        |
| Managed Identities (System / User Assigned) | `managedIdentities`  | `managed_identities`    | MUST        |
| Private Endpoints                           | `privateEndpoints`   | `private_endpoints`     | MUST        |
| Customer Managed Keys                       | `customerManagedKey` | `customer_managed_key`  | MUST        |
| Azure Monitor Alerts                        | `alerts`             | `alerts`                | SHOULD      |

{{< hint type=note >}}

Please note that the implementation of Customer Managed Keys from an ARM API perspective is different across various RPs that implement Customer Managed Keys in their service. For that reason you may see differences between modules on how Customer Managed Keys are handled and implemented, but functionality will be as expected.

{{< /hint >}}

Module owners **MAY** choose to utilize cross repo dependencies for these "add-on" resources, or **MAY** chose to implement the code directly in their own repo/module. So long as the implementation and outputs are as per the specifications requirements, then this is acceptable.

{{< hint type=tip >}}

Make sure to checkout the language specific specifications for more info on this:

- [Bicep](/Azure-Verified-Modules/specs/bicep#id-bcpnfr1---category-composition---cross-referencing-modules)
- [Terraform](/Azure-Verified-Modules/specs/terraform#id-tfnfr1---category-composition---cross-referencing-modules)

{{< /hint >}}

#### ID: RMFR5 - Category: Composition - AVM Consistent Feature & Extension Resources Value Add Interfaces/Schemas

Modules **MUST** implement a common interface, e.g. the input's data structures and properties within them (objects/arrays/dictionaries/maps), for the optional features/extension resources:

See:

- [Diagnostic Settings Interface](/Azure-Verified-Modules/specs/shared/interfaces/#diagnostic-settings)
- [Role Assignments Interface](/Azure-Verified-Modules/specs/shared/interfaces/#role-assignments)
- [Resource Locks Interface](/Azure-Verified-Modules/specs/shared/interfaces/#resource-locks)
- [Tags Interface](/Azure-Verified-Modules/specs/shared/interfaces/#tags)
- [Managed Identities Interface](/Azure-Verified-Modules/specs/shared/interfaces/#managed-identities)
- [Private Endpoints Interface](/Azure-Verified-Modules/specs/shared/interfaces/#private-endpoints)
- [Customer Managed Keys Interface](/Azure-Verified-Modules/specs/shared/interfaces/#customer-managed-keys)
- [Alerts Interface](/Azure-Verified-Modules/specs/shared/interfaces/#azure-monitor-alerts)

#### ID: RMFR6 - Category: Inputs - Parameter/Variable Naming

Parameters/variables that pertain to the primary resource **MUST NOT** use the resource type in the name.

e.g., use `sku`, vs. `virtualMachineSku`/`virtualmachine_sku`

Another example for where RPs contain some of their name within a property, leave the property unchanged. E.g. Key Vault has a property called `keySize`, it is fine to leave as this and not remove the `key` part from the property/parameter name.

### Non-Functional Requirements

#### ID: RMNFR1 - Category: Naming - Module Naming

Module names **MUST** follow the below pattern (all lower case):

- Bicep: `avm-res-<rp>-<armresourcename>` (to support registry hosting)
- Terraform:
  - `avm-res-<rp>-<armresourcename>` (Module name for registry)
  - `terraform-<provider>-avm-res-<rp>-<armresourcename>` (GitHub repository name to meet registry naming requirements)

Example: `avm-res-compute-virtualmachine`

- `<armresourcename>` is the singular version of the word after the resource provider, e.g., `Microsoft.Compute/virtualMachines` = `virtualmachine`
- `<rp>` is the resource provider’s name after the `Microsoft` part, e.g., `Microsoft.Compute` = `compute`.
- `res` defines this is a resource module
- `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` or `azuread` for resource modules.

{{< hint type=note >}}

We will maintain a JSON file in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/issues) with the correct singular names for all resource types to enable checks to utilize this list to ensure repos are named correctly.

This will be updated quarterly, or ad-hoc as new RPs/ Resources are created and highlighted via a check failure.

{{< /hint >}}

#### ID: RMNFR2 - Category: Inputs - Parameter/Variable Naming

A module **SHOULD** use the following standard inputs:

- `name` (no default)
- `location` (use Resource Group location, if resource supports Resource Groups, otherwise no default)

#### ID: RMNFR3 - Category: Composition - RP Collaboration

Module owners (Microsoft FTEs) **SHOULD** reach out to the respective Resource Provider teams to build a partnership and collaboration on the modules creation, existence and long term maintenance.

Review this [wiki page (TBC)](/Azure-Verified-Modules/specs/shared/#id-rmnfr3---category-composition---rp-collaboration) for more information.

## Pattern Module Requirements

Listed below are both functional and non-functional requirements for [AVM Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Functional Requirements

#### ID: PMFR1 - Category: Composition - Resource Group Creation

A module **MAY** create Resource Group(s).

### Non-Functional Requirements

#### ID: PMNFR1 - Category: Naming - Module Naming

Module names **MUST** follow the below pattern (all lower case):

- Bicep: `avm-ptn-<patternmodulename>`
- Terraform: `terraform-<provider>-avm-ptn-<patternmodulename>`
  - `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` for pattern modules.

Example: `avm-ptn-apptiervmss`

- `<patternmodulename>` is a term describing the module’s function, e.g., `apptiervmss` = Application Tier VMSS
- `ptn` defines this as a pattern module

#### ID: PMNFR2 - Category: Composition - Use Resource Modules to Build a Pattern Module

A module **SHOULD** be built from the required AVM Resources Modules

#### ID: PMNFR3 - Category: Composition - Use other Pattern Modules to Build a Pattern Module

A module **MAY** contain and be built using other AVM Pattern Modules

#### ID: PMNFR4 - Category: Hygiene - Missing Resource Module/s

An item **MUST** be logged onto as an issue on the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/issues) if a Resource Module does not exist for resources deployed by the pattern module.

{{< hint type=important title=Exception >}}

If the Resource Module adds no value, see Resource Module functional requirement [ID: RMFR2](#id-rmfr2---category-composition---no-resource-wrapper-modules)

{{< /hint >}}

#### ID: PMNFR5 - Category: Inputs - Parameter/Variable Naming

Parameter/variable input names **SHOULD** contain the resource to which they pertain. E.g., `virtualMachineSku`/`virtualmachine_sku`
