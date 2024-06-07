---
title: Shared Specification (Bicep & Terraform)
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/shared/
---

{{< hint type=tip >}}

Make sure to checkout the [Module Classification Definitions](/Azure-Verified-Modules/specs/shared/module-classifications/) first before reading further so you understand the difference between a Resource and Pattern Module in AVM.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

<br>

This page contains the shared **requirements for both Bicep and Terraform** AVM modules (**Resource and Pattern modules**) that ALL AVM modules **MUST** meet. In addition to these, requirements specific to each language, defined in their respective specifications also **MUST** be met. See [Bicep](/Azure-Verified-Modules/specs/bicep/) and [Terraform](/Azure-Verified-Modules/specs/terraform/) specific requirements for more information.

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements               | Non-functional requirements                 |
|--------------------------------------------------|---------------------------------------|---------------------------------------------|
| Shared requirements (resource & pattern modules) | [SFR](#functional-requirements-sfr)   | [SNFR](#non-functional-requirements-snfr)   |
| Resource module level requirements               | [RMFR](#functional-requirements-rmfr) | [RMNFR](#non-functional-requirements-rmnfr) |
| Pattern module level requirements                | [PMFR](#functional-requirements-pmfr) | [PMNFR](#non-functional-requirements-pmnfr) |

<br>

{{< toc >}}


<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for both classifications of AVM modules (Resource and Pattern) and all languages.

{{< hint type=note >}}

While every effort is being made to standardize requirements and implementation details across all languages, it is expected that some of the specifications will be different between their respective languages to ensure we follow the best practices and leverage features of each language.

{{< /hint >}}

<br>

### Functional Requirements (SFR)

{{< hint type=note >}}
This section includes **shared, functional requirements (SFR)** for Bicep an Terraform AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

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

<br>

---

<br>

#### ID: SFR2 - Category: Composition - WAF Aligned

Modules **SHOULD** set defaults in input parameters/variables to align to **high** priority/impact recommendations, where appropriate and applicable, in the following frameworks and resources:

- [Well-Architected Framework (WAF)](https://learn.microsoft.com/azure/well-architected/what-is-well-architected-framework)
- [Reliability Hub](https://learn.microsoft.com/azure/reliability/overview-reliability-guidance)
- [Azure Proactive Resiliency Library (APRL)](https://aka.ms/aprl)
  - *Only Product Group (PG) verified*
- [Microsoft Cloud Security Benchmark (MCSB)](https://learn.microsoft.com/security/benchmark/azure/introduction)
- [Microsoft Defender for Cloud (MDFC)](https://learn.microsoft.com/en-us/azure/defender-for-cloud/recommendations-reference)

They **SHOULD NOT** align to these recommendations when it requires an external dependency/resource to be deployed and configured and then associated to the resources in the module.

Alignment **SHOULD** prioritize best-practices and security over cost optimization, but **MUST** allow for these to be overridden by a module consumer easily, if desired.

{{< hint type=tip >}}

Read the FAQ of [What does AVM mean by “WAF Aligned”?](/Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned) for more detailed information and examples.

{{< /hint >}}

<br>

---

<br>

#### ID: SFR3 - Category: Telemetry - Deployment/Usage Telemetry

{{< hint type=important >}}

We will maintain a set of CSV files in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) with the required TelemetryId prefixes to enable checks to utilize this list to ensure the correct IDs are used. To see the formatted content of these CSV files with additional information, please visit the [AVM Module Indexes](/Azure-Verified-Modules/indexes) page.

These will also be provided as a comment on the module proposal, once accepted, from the AVM core team.

{{< /hint >}}

Modules **MUST** provide the capability to collect deployment/usage telemetry, via a blank ARM deployment, as detailed in [Telemetry](/Azure-Verified-Modules/help-support/telemetry/) further. Telemetry data should be collected on the "top level" `main.bicep` or `main.telemetry.tf` file; it is not necessary to include it in any nested files (child modules).


To highlight that AVM modules use telemetry, an information notice **MUST** be included in the footer of each module's `README.md` file with the below content. (See more details on this requirement, [here](https://docs.opensource.microsoft.com/releasing/general-guidance/telemetry/).)

{{< expand "➕ Telemetry Information Notice" "expand/collapse" >}}

{{< hint type=note >}}
The following information notice is automatically added at the bottom of the `README.md` file of the module when
- **Bicep:** Using the [`avm/utilities/tools/Set-AVMModule.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/tools/Set-AVMModule.ps1) utility
- **Terraform:** Executing the `make docs` command with the note and header `## Data Collection` being placed in the module's `_footer.md` beforehand
{{< /hint >}}

`## Data Collection`
{{< include file="static/includes/telemetry-information-notice.md" language="md" options="linenos=false" >}}

{{< /expand >}}

The ARM deployment name used for the telemetry **MUST** follow the pattern and **MUST** be no longer than 64 characters in length: `<AVM 8 chars (alphanumeric)>.<res/ptn>.<(short) module name>.<version>.<uniqueness>`

- `<AVM 8 chars (alphanumeric)>`
  - Bicep == `46d3xbcp`
  - Terraform == `46d3xgtf`
- `<res/ptn>` == AVM Resource or Pattern Module
- `<(short) module name>` == The AVM Module's, possibly shortened, name including the resource provider and the resource type, **without**;
  - The prefixes: `avm-res-` or `terraform-<provider>-avm-res-`
  - The prefixes: `avm-ptn-` or `terraform-<provider>-avm-ptn-`

{{< hint type=note >}}

Due to the 64-character length limit of Azure deployment names, the `<(short) module name>` segment has a length limit of 36 characters, so if the module name is longer than that, it **MUST** be truncated to 36 characters. If any of the semantic version's segments are longer than 1 character, it further restricts the number of characters that can be used for naming the module.

{{< /hint >}}

- `<version>` == The AVM Module's MAJOR.MINOR version (only) with `.` (periods) replaced with `-` (hyphens), to allow simpler splitting of the ARM deployment name
- `<uniqueness>` == This section of the ARM deployment name is to be used to ensure uniqueness of the deployment name.
  - This is to cater for the following scenarios:
    - The module is deployed multiple times to the same:
      - Location/Region
      - Scope (Tenant, Management Group,Subscription, Resource Group)

An example deployment name for the AVM Virtual Machine Resource Module would be:

- Bicep == `46d3xbcp.res.compute-virtualmachine.1-2-3.eum3`
- Terraform == `46d3xgtf.res.compute-virtualmachine.1-2-3.eum3`

An example deployment name for a shortened module name would be:

- Bicep == `46d3xbcp.res.desktopvirtualization-appgroup.1-2-3.eum3`
- Terraform == `46d3xgtf.res.desktopvirtualization-appgroup.1-2-3.eum3`

{{< hint type=tip >}}

See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep](/Azure-Verified-Modules/contributing/bicep/)
- [Terraform](/Azure-Verified-Modules/contributing/terraform/)

{{< /hint >}}

<br>

---

<br>

#### ID: SFR4 - Category: Telemetry - Telemetry Enablement Flexibility

The telemetry enablement **MUST** be on/enabled by default, however this **MUST** be able to be disabled by a module consumer by setting the below parameter/variable value to `false`:

- Bicep: `enableTelemetry`
- Terraform: `enable_telemetry`

<br>

---

<br>

#### ID: SFR5 - Category: Composition - Availability Zones

Modules that deploy ***zone-redundant*** resources **MUST** enable the spanning across as many zones as possible by default, typically all 3.

Modules that deploy ***zonal*** resources **MUST** provide the ability to specify a zone for the resources to be deployed/pinned to. However, they **MUST NOT** default to a particular zone by default, e.g. `1` in an effort to make the consumer aware of the zone they are selecting to suit their architecture requirements.

For both scenarios the modules **MUST** expose these configuration options via configurable parameters/variables.

{{< hint type=note >}}

For information on the differences between zonal and zone-redundant services, see [Availability zone service and regional support](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-service-support#azure-services-with-availability-zone-support)

{{< /hint >}}

<br>

---

<br>

#### ID: SFR6 - Category: Composition - Data Redundancy

Modules that deploy resources or patterns that support data redundancy **SHOULD** enable this to the highest possible value by default, e.g. `RA-GZRS`. When a resource or pattern doesn't provide the ability to specify data redundancy as a simple property, e.g. `GRS` etc., then the modules **MUST** provide the ability to enable data redundancy for the resources or pattern via parameters/variables.

For example, a Storage Account module can simply set the `sku.name` property to `Standard_RAGZRS`. Whereas a SQL DB or Cosmos DB module will need to expose more properties, via parameters/variables, to allow the specification of the regions to replicate data to as per the consumers requirements.

{{< hint type=note >}}

For information on the data redundancy options in Azure, see [Cross-region replication in Azure](https://learn.microsoft.com/en-us/azure/reliability/cross-region-replication-azure)

{{< /hint >}}

<br>

---

<br>

### Non-Functional Requirements (SNFR)

{{< hint type=note >}}
This section includes **shared, non-functional requirements (SNFR)** for Bicep an Terraform AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: SNFR25 - Category: Composition - Resource Naming

Module owners **MUST** set the default resource name prefix for child, extension, and interface resources to the associated abbreviation for the specific resource as documented in the following CAF article [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), if specified and documented. This reduces the amount of input values a module consumer **MUST** provide by default when using the module.

For example, a Private Endpoint that is being deployed as part of a resource module, via the mandatory interfaces, **MUST** set the Private Endpoint's default name to begin with the prefix of `pep-`.

Module owners **MUST** also provide the ability for these default names, including the prefixes, to be overridden via a parameter/variable if the consumer wishes to.

Furthermore, as per [RMNFR2](/Azure-Verified-Modules/specs/shared#id-snfr22---category-inputs---parametersvariables-for-resource-ids), Resource Modules **MUST** not have a default value specified for the name of the primary resource and therefore the name **MUST** be provided and specified by the module consumer.

The name provided **MAY** be used by the module owner to generate the rest of the default name for child, extension, and interface resources if they wish to. For example, for the Private Endpoint mentioned above, the full default name that can be overridden by the consumer, **MAY** be `pep-<primary-resource-name>`.

{{< hint type=tip >}}

If the resource does not have a documented abbreviation in [Abbreviation examples for Azure resources](https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations), then the module owner is free to use a sensible prefix instead.

{{< /hint >}}

<br>

---

<br>

#### ID: SNFR1 - Category: Testing - Prescribed Tests

Modules **MUST** use the prescribed tooling and testing frameworks defined in the language specific specs.

<br>

---

<br>

#### ID: SNFR2 - Category: Testing - E2E Testing

Modules **MUST** implement end-to-end (deployment) testing that create actual resources to validate that module deployments work. In Bicep tests are sourced from the directories in `/tests/e2e`. In Terraform, these are in `/examples`.

Each test **MUST** run and complete without user inputs successfully, for automation purposes.

Each test **MUST** also destroy/clean-up its resources and test dependencies following a run.

{{< hint type=tip >}}

To see a directory and file structure for a module, see the language specific contribution guide.

- [Bicep](/Azure-Verified-Modules/contributing/bicep#directory-and-file-structure)
- [Terraform](/Azure-Verified-Modules/contributing/terraform#directory-and-file-structure)

{{< /hint >}}

##### Required Resources/Dependencies Required for E2E Tests

It is likely that to complete E2E tests, a number of resources will be required as dependencies to enable the tests to pass successfully. Some examples:

- When testing the Diagnostic Settings interface for a Resource Module, you will need an existing Log Analytics Workspace to be able to send the logs to as a destination.
- When testing the Private Endpoints interface for a Resource Module, you will need an existing Virtual Network, Subnet and Private DNS Zone to be able to complete the Private Endpoint deployment and configuration.

Module owners **MUST**:

- Create the required resources that their module depends upon in the test file/directory
  - They **MUST** either use:
    - Simple/native resource declarations/definitions in their respective IaC language, <br> **OR**
    - Another already published AVM Module that **MUST** be pinned to a specific published version.
      - They **MUST NOT** use any local directory path references or local copies of AVM modules in their own modules test directory.

{{< expand "➕ Terraform & Bicep Log Analytics Workspace examples using simple/native declarations for use in E2E tests" "expand/collapse">}}

###### Terraform

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rsg-test-001"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "law-test-001"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
```

###### Bicep

```bicep
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'law-test-001'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}
```
{{< /expand >}}

<br>

---

<br>

#### ID: SNFR3 - Category: Testing - AVM Compliance Tests

Modules **MUST** pass all tests that ensure compliance to AVM specifications. These tests **MUST** pass before a module version can be published.

{{< hint type=important >}}

Please note these are still under development at this time and will be published and available soon for module owners.

Module owners **MUST** request a manual GitHub Pull Request review, prior to their first release of version `0.1.0` of their module, from the related GitHub Team: [`@Azure/avm-core-team-technical-bicep`](https://github.com/orgs/Azure/teams/avm-core-team-technical-bicep), OR [`@Azure/avm-core-team-technical-terraform`](https://github.com/orgs/Azure/teams/avm-core-team-technical-terraform).

{{< /hint >}}

<br>

---

<br>

#### ID: SNFR4 - Category: Testing - Unit Tests

Modules **SHOULD** implement unit testing to ensure logic and conditions within parameters/variables/locals are performing correctly. These tests **MUST** pass before a module version can be published.

Unit Tests test specific module functionality, without deploying resources. Used on more complex modules. In Bicep and Terraform these live in `tests/unit`.

<br>

---

<br>

#### ID: SNFR5 - Category: Testing - Upgrade Tests

Modules **SHOULD** implement upgrade testing to ensure new features are implemented in a non-breaking fashion on non-major releases.

<br>

---

<br>

#### ID: SNFR6 - Category: Testing - Static Analysis/Linting Tests

Modules **MUST** use static analysis, e.g., linting, security scanning (PSRule, tflint, etc.). These tests **MUST** pass before a module version can be published.

There may be differences between languages in linting rules standards, but the AVM core team will try to close these and bring them into alignment over time.

<br>

---

<br>

#### ID: SNFR7 - Category: Testing - Idempotency Tests

Modules **MUST** implement idempotency end-to-end (deployment) testing. E.g. deploying the module twice over the top of itself.

Modules **SHOULD** pass the idempotency test, as we are aware that there are some exceptions where they may fail as a false-positive or legitimate cases where a resource cannot be idempotent.

For example, Virtual Machine Image names must be unique on each resource creation/update.

<br>

---

<br>

#### ID: SNFR24 - Category: Testing - Testing Child, Extension & Interface Resources

Module owners **MUST** test that child, extension and [interface resources](/Azure-Verified-Modules/specs/shared/interfaces/), that are supported by their modules, are tested in E2E tests as per [SNFR2](/Azure-Verified-Modules/specs/shared#id-snfr2---category-testing---e2e-testing) to ensure they deploy and are configured correctly.

These **MAY** be tested in a separate E2E test and **DO NOT** have to be tested in each E2E test.

<br>

---

<br>

#### ID: SNFR8 - Category: Contribution/Support - Module Owner(s) GitHub

A module **MUST** have an owner that is defined and managed by a GitHub Team in the Azure GitHub organization.

Today this is only Microsoft FTEs, but everyone is welcome to contribute. The module just **MUST** be owned by a Microsoft FTE (today) so we can enforce and provide the long-term support required by this initiative.

{{< hint type=note >}}

The names for the GitHub teams for each approved module are already defined in the respective [Module Indexes](/Azure-Verified-Modules/indexes/). These teams **MUST** be created (and used) for each module.

{{< /hint >}}

<br>

---

<br>

#### ID: SNFR20 - Category: Contribution/Support - GitHub Teams Only

All GitHub repositories that AVM module are published from and hosted within **MUST** only assign GitHub repository permissions to GitHub teams only.

Each module **MUST** have separate GitHub teams assigned for module owners **AND** module contributors respectively. These GitHub teams **MUST** be created in the [Azure organization](https://github.com/orgs/Azure/teams) in GitHub.

There **MUST NOT** be any GitHub repository permissions assigned to individual users.

{{< hint type=note >}}
The names for the GitHub teams for each approved module are already defined in the respective [Module Indexes](/Azure-Verified-Modules/indexes/). These teams **MUST** be created (and used) for each module.

- [Bicep Resource Modules](/Azure-Verified-Modules/indexes/bicep/bicep-resource-modules/#module-name-telemetry-id-prefix-github-teams-for-owners--contributors)
- [Bicep Pattern Modules](/Azure-Verified-Modules/indexes/bicep/bicep-pattern-modules/#module-name-telemetry-id-prefix-github-teams-for-owners--contributors)
- [Terraform Resource Modules](/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/#module-name-telemetry-id-prefix-github-teams-for-owners--contributors)
- [Terraform Pattern Modules](/Azure-Verified-Modules/indexes/terraform/tf-pattern-modules/#module-name-telemetry-id-prefix-github-teams-for-owners--contributors)

The `@Azure` prefix in the last column of the tables linked above represents the "Azure" GitHub organization all AVM-related repositories exist in. **DO NOT** include this segment in the team's name!

{{< /hint >}}

{{< hint type=important >}}
Non-FTE / external contributors (subject matter experts that aren't Microsoft employees) can't be members of the teams described in this chapter, hence, they won't gain any extra permissions on AVM repositories, therefore, they need to work in forks.
{{< /hint >}}

<br>

##### Naming Convention

The naming convention for the GitHub teams **MUST** follow the below pattern:

- `<hyphenated module name>-module-owners-<bicep/tf>` - to be assigned as the GitHub repository's `Module Owners` team
- `<hyphenated module name>-module-contributors-<bicep/tf>` - to be assigned as the GitHub repository's `Module Contributors` team

{{< hint type=note >}}
The naming convention for Bicep modules is slightly different than the naming convention for their respective GitHub teams.
{{< /hint >}}

Segments:

- `<hyphenated module name>` == the AVM Module's name, with each segment separated by dashes, i.e., `avm-res-<resource provider>-<ARM resource type>`
  - See [RMNFR1](#id-rmnfr1---category-naming---module-naming) for AVM Resource Module Naming
  - See [PMNFR1](#id-pmnfr1---category-naming---module-naming) for AVM Pattern Module Naming
- `module-owners` or `module-contributors` == the role the GitHub Team is assigned to
- `<bicep/tf>` == the language the module is written in

Examples:

- `avm-res-compute-virtualmachine-module-owners-bicep`
- `avm-res-compute-virtualmachine-module-contributors-tf`

<br>

##### Add Team Members

All officially documented module owner(s) **MUST** be added to the `-module-owners-` team. The `-module-owners-` team **MUST NOT** have any other members.

Any additional module contributors whom the module owner(s) agreed to work with **MUST** be added to the `-module-contributors-` team.

Unless explicitly requested and agreed, members of the AVM core team or any PG teams **MUST NOT** be added to the `-module-owners-` or `-module-contributors-` teams as permissions for them are granted through the teams described in [SNFR9](/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions).

<br>

##### Grant Permissions - Bicep

##### Team memberships

{{< hint type=note >}}

In case of Bicep modules, permissions to the [BRM](https://aka.ms/BRM) repository (the repo of the Bicep Registry) are granted via assigning the `-module-owners-` and `-module-contributors-` teams to parent teams that already have the required level access configured. While it is the module owner's responsibility to initiate the addition of their teams to the respective parents, only the AVM core team can approve this parent-child relationship.

{{< /hint >}}

Module owners **MUST** create their `-module-owners-` and `-module-contributors-` teams and as part of the provisioning process, they **MUST** request the addition of these teams to their respective parent teams (see the table below for details).

| GitHub Team Name                                     | Description                                    | Permissions | Permissions granted through                                        | Where to work?          |
|------------------------------------------------------|------------------------------------------------|-------------|--------------------------------------------------------------------|-------------------------|
| `<hyphenated module name>-module-owners-bicep`       | AVM Bicep Module Owners - \<module name>       | **Write**   | Assignment to the **`avm-technical-reviewers-bicep`** parent team. | Need to work in a fork. |
| `<hyphenated module name>-module-contributors-bicep` | AVM Bicep Module Contributors - \<module name> | **Triage**  | **`avm-module-contributors-bicep`** parent team.                   | Need to work in a fork. |

Examples - GitHub teams required for the Bicep resource module of Azure Virtual Network (`avm/res/network/virtual-network`):

- `avm-res-network-virtualnetwork-module-owners-bicep` --> assign to the `avm-technical-reviewers-bicep` parent team.
- `avm-res-network-virtualnetwork-module-contributors-bicep` --> assign to the `avm-module-contributors-bicep` parent team.

{{< hint type=tip >}}
Direct link to create a new GitHub team and assign it to its parent: [Create new team](https://github.com/orgs/Azure/new-team)

Fill in the values as follows:

- **Team name**: Following the naming convention described above, use the value defined in the module indexes.
- **Description**: Follow the guidance above (see the Description column in the table above).
- **Parent team**: Follow the guidance above (see the Permissions granted through column in the table above).
- **Team visibility**: `Visible`
- **Team notifications**: `Enabled`
{{< /hint >}}

##### CODEOWNERS file

As part of the "initial Pull Request" (that publishes the first version of the module), module owners **MUST** add an entry to the `CODEOWNERS` file in the BRM repository ([here](https://github.com/Azure/bicep-registry-modules/blob/main/.github/CODEOWNERS)).

{{< hint type=note >}}
Through this approach, the AVM core team will grant review permission to module owners as part of the standard PR review process.
{{< /hint >}}

Every `CODEOWNERS` entry (line) **MUST** include the following segments separated by a single whitespace character:

- Path of the module, relative to the repo's root, e.g.: `/avm/res/network/virtual-network/`
- The `-module-owners-`team, with the `@Azure/` prefix, e.g., `@Azure/avm-res-network-virtualnetwork-module-owners-bicep`
- The GitHub team of the AVM core team, with the `@Azure/` prefix, i.e., `@Azure/avm-core-team-technical-bicep`

Example - `CODEOWNERS` entry for the Bicep resource module of Azure Virtual Network (`avm/res/network/virtual-network`):

- `/avm/res/network/virtual-network/ @Azure/avm-res-network-virtualnetwork-module-owners-bicep @Azure/avm-core-team-technical-bicep`

<br>

##### Grant Permissions - Terraform

Module owners **MUST** assign the `-module-owners-`and `-module-contributors-` teams the necessary permissions on their Terraform module repository per the guidance below.

| GitHub Team Name                       | Description                                       | Permissions | Permissions granted through | Where to work?                                                                                |
|----------------------------------------|---------------------------------------------------|-------------|-----------------------------|-----------------------------------------------------------------------------------------------|
| `<module name>-module-owners-tf`       | AVM Terraform Module Owners - \<module name>       | **Admin**   | Direct assignment to repo   | Module owner can decide whether they want to work in a branch local to the repo or in a fork. |
| `<module name>-module-contributors-tf` | AVM Terraform Module Contributors - \<module name> | **Write**   | Direct assignment to repo   | Need to work in a fork.                                                                       |

{{< hint type=tip >}}
Direct link to create a new GitHub team: [Create new team](https://github.com/orgs/Azure/new-team)

Fill in the values as follows:

- **Team name**: Following the naming convention described above, use the value defined in the module indexes.
- **Description**: Follow the guidance above (see the Description column in the table above).
- **Parent team**: Do not assign the team to any parent team.
- **Team visibility**: `Visible`
- **Team notifications**: `Enabled`
{{< /hint >}}

<br>

---

<br>

#### ID: SNFR9 - Category: Contribution/Support - AVM & PG Teams GitHub Repo Permissions

A module owner **MUST** make the following GitHub teams in the Azure GitHub organization admins on the GitHub repo of the module in question:

##### Bicep

- [`@Azure/avm-core-team-technical-bicep`](https://github.com/orgs/Azure/teams/avm-core-team-technical-bicep) = AVM Core Team
- [`@Azure/bicep-admins`](https://github.com/orgs/Azure/teams/bicep-admins) = Bicep PG team

{{< hint type=note >}}
These required GitHub teams are already associated to the [BRM](https://aka.ms/BRM) repository and have the required permissions.
{{< /hint >}}

##### Terraform

- [`@Azure/avm-core-team-technical-terraform`](https://github.com/orgs/Azure/teams/avm-core-team-technical-terraform) = AVM Core Team
- [`@Azure/terraform-avm`](https://github.com/orgs/Azure/teams/terraform-avm) = Terraform PG

{{< hint type=important >}}
Module owners **MUST** assign these GitHub teams as admins on the GitHub repo of the module in question.

For detailed steps, please follow this [guidance](https://docs.github.com/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/managing-teams-and-people-with-access-to-your-repository#inviting-a-team-or-person).
{{< /hint >}}

<br>

---

<br>

#### ID: SNFR10 - Category: Contribution/Support - MIT Licensing

A module **MUST** be published with the MIT License in the Azure GitHub organization.

<br>

---

<br>

#### ID: SNFR11 - Category: Contribution/Support - Issues Response Times

A module owner **MUST** respond to logged issues within 3 business days. See [Module Support](/Azure-Verified-Modules/help-support/module-support/) for more information.

<br>

---

<br>

#### ID: SNFR12 - Category: Contribution/Support - Versions Supported

Only the latest released version of a module **MUST** be supported.

For example, if an AVM Resource Module is used in an AVM Pattern Module that was working but now is not. The first step by the AVM Pattern Module owner should be to upgrade to the latest version of the AVM Resource Module test and then if not fixed, troubleshoot and fix forward from the that latest version of the AVM Resource Module onwards.

This avoids AVM Module owners from having to maintain multiple major release versions.

<br>

---

<br>

#### ID: SNFR23 - Category: Contribution/Support - GitHub Repo Labels

GitHub repositories where modules are held **MUST** use the below labels and **SHOULD** not use any additional labels:

{{< expand "➕ AVM Standard GitHub Labels" "expand/collapse" >}}

These labels are available in a CSV file from [here](/Azure-Verified-Modules/governance/avm-standard-github-labels.csv)

{{< ghLabelsCsvToTable header=true csv="/static/governance/avm-standard-github-labels.csv" >}}

{{< /expand >}}

To help apply these to a module GitHub repository you can use the below PowerShell script:

{{< expand "➕ Set-AvmGitHubLabels.ps1" "expand/collapse" >}}

For most scenario this is the command you'll need to call the below PowerShell script with, replacing the value for `RepositoryName`:

```powershell
Set-AvmGitHubLabels.ps1 -RepositoryName "Org/MyGitHubRepo" -CreateCsvLabelExports $false -NoUserPrompts $true
```

```shell
# Linux / MacOs
# For Windows replace $PWD with your the local path or your repository
#
docker run -it -v $PWD:/repo -w /repo mcr.microsoft.com/powershell pwsh -Command '
    #Invoke-WebRequest -Uri "https://azure.github.io/Azure-Verified-Modules/scripts/Set-AvmGitHubLabels.ps1" -OutFile "Set-AvmGitHubLabels.ps1"
    $gh_version = "2.44.1"
    Invoke-WebRequest -Uri "https://github.com/cli/cli/releases/download/v2.44.1/gh_2.44.1_linux_amd64.tar.gz" -OutFile "gh_$($gh_version)_linux_amd64.tar.gz"
    apt-get update && apt-get install -y git
    tar -xzf "gh_$($gh_version)_linux_amd64.tar.gz"
    ls -lsa
    mv "gh_$($gh_version)_linux_amd64/bin/gh" /usr/local/bin/
    rm "gh_$($gh_version)_linux_amd64.tar.gz" && rm -rf "gh_$($gh_version)_linux_amd64"
    gh --version
    ls -lsa
    gh auth login
    $OrgProject = "Azure/terraform-azurerm-avm-res-kusto-cluster"
    gh auth status
    ./Set-AvmGitHubLabels.ps1 -RepositoryName $OrgProject -CreateCsvLabelExports $false -NoUserPrompts $true
  '
```

By default this script will only update and append labels on the repository specified. However, this can be changed by setting the parameter `-UpdateAndAddLabelsOnly` to `$false`, which will remove all the labels from the repository first and then apply the AVM labels from the CSV only.

Make sure you elevate your privilege to admin level or the labels will not be applied to your repository. Go to repos.opensource.microsoft.com/orgs/Azure/repos/<your avm repo> to request admin access before running the script.

Full Script:

These `Set-AvmGitHubLabels.ps1` can be downloaded from <a href="/Azure-Verified-Modules/scripts/Set-AvmGitHubLabels.ps1" download>here</a>.

{{< include file="/static/scripts/Set-AvmGitHubLabels.ps1" language="powershell" options="linenos=false" >}}

{{< /expand >}}

<br>

---

<br>

#### ID: SNFR14 - Category: Inputs - Data Types

A module **SHOULD** use either: simple data types. e.g., string, int, bool.

OR

Complex data types (objects, arrays, maps) when the language-compliant schema is defined.

<br>

---

<br>

#### ID: SNFR22 - Category: Inputs - Parameters/Variables for Resource IDs

A module parameter/variable that requires a full Azure Resource ID as an input value, e.g. `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}`, **MUST** contain `ResourceId/resource_id` in its parameter/variable name to assist users in knowing what value to provide at a glance of the parameter/variable name.

Example for the property `workspaceId` for the Diagnostic Settings resource. In Bicep its parameter name should be `workspaceResourceId` and the variable name in Terraform should be `workspace_resource_id`.

`workspaceId` is not descriptive enough and is ambiguous as to which ID is required to be input.

<br>

---

<br>

#### ID: SNFR15 - Category: Documentation - Automatic Documentation Generation

README documentation **MUST** be automatically/programmatically generated. **MUST** include the sections as defined in the language specific requirements [BCPNFR2](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr2---category-documentation---module-documentation-generation), [TFNFR2](/Azure-Verified-Modules/specs/terraform/#id-tfnfr2---category-documentation---module-documentation-generation).

<br>

---

<br>

#### ID: SNFR16 - Category: Documentation - Examples/E2E

An examples/e2e directory **MUST** exist to provide named scenarios for module deployment.

<br>

---

<br>

#### ID: SNFR17 - Category: Release - Semantic Versioning

{{< hint type=important >}}

You cannot specify the patch version for Bicep modules in the public Bicep Registry, as this is automatically incremented by 1 each time a module is published. You can only set the Major and Minor versions.

See the [Bicep Contribution Guide](/Azure-Verified-Modules/contributing/bicep/) for more information.

{{< /hint >}}

Modules **MUST** use semantic versioning (aka semver) for their versions and releases in accordance with: [Semantic Versioning 2.0.0](https://semver.org/)

For example all modules should be released using a semantic version that matches this pattern: `X.Y.Z`

- `X` == Major Version
- `Y` == Minor Version
- `Z` == Patch Version

##### Module versioning before first Major version release `1.0.0`

- Initially modules MUST be released as version `0.1.0` and incremented via Minor and Patch versions only until the AVM Core Team are confident the AVM specifications are mature enough and appropriate CI test coverage is in place, plus the module owner is happy the module has been "road tested" and is now stable enough for its first Major release of version `1.0.0`.

  {{< hint type=note >}}

  Releasing as version `0.1.0` initially and only incrementing Minor and Patch versions allows the module owner to make breaking changes more easily and frequently as it's still not an official Major/Stable release. 👍

  {{< /hint >}}

- Until first Major version `1.0.0` is released, given a version number `X.Y.Z`:
  - `X` Major version MUST NOT be bumped.
  - `Y` Minor version MUST be bumped when introducing breaking changes (which would normally bump Major after `1.0.0` release) or feature updates (same as it will be after `1.0.0` release).
  - `Z` Patch version MUST be bumped when introducing non-breaking, backward compatible bug fixes (same as it will be after `1.0.0` release).

<br>

---

<br>

#### ID: SNFR18 - Category: Release - Breaking Changes

A module **SHOULD** avoid breaking changes, e.g., deprecating inputs vs. removing.

<br>

---

<br>

#### ID: SNFR19 - Category: Publishing - Registries Targeted

Modules **MUST** be published to their respective language public registries.

- Bicep = [Bicep Public Module Registry](https://aka.ms/BRM)
  - Within the `avm` directory
- Terraform = [HashiCorp Terraform Registry](https://registry.terraform.io/)

{{< hint type=tip >}}

See the language specific contribution guides for detailed guidance and sample code to use in AVM modules to achieve this requirement.

- [Bicep](/Azure-Verified-Modules/contributing/bicep/)
- [Terraform](/Azure-Verified-Modules/contributing/terraform/)

{{< /hint >}}

<br>

---

<br>

#### ID: SNFR21 - Category: Publishing - Cross Language Collaboration

When the module owners of the same Resource or Pattern AVM module are not the same individual or team for all languages, each languages team **SHOULD** collaborate with their sibling language team for the same module to ensure consistency where possible.

<br>

---

<br>
<br>

## Resource Module Requirements

Listed below are both functional and non-functional requirements for [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

<br>

### Functional Requirements (RMFR)

{{< hint type=note >}}
This section includes **resource module level, functional requirements (RMFR)** for Bicep an Terraform.
{{< /hint >}}

---

<br>

#### ID: RMFR1 - Category: Composition - Single Resource Only

A resource module **MUST** only deploy a single instance of the primary resource, e.g., one virtual machine per instance.

Multiple instances of the module **MUST** be used to scale out.

<br>

---

<br>

#### ID: RMFR2 - Category: Composition - No Resource Wrapper Modules

A resource module **MUST** add value by including additional features on top of the primary resource.

<br>

---

<br>

#### ID: RMFR3 - Category: Composition - Resource Groups

A resource module **MUST NOT** create a Resource Group **for resources that require them.**

In the case that a Resource Group is required, a module **MUST** have an input (scope or variable):

- In Bicep the `targetScope` **MUST** be set to `resourceGroup` or not specified (which means default to `resourceGroup` scope)
- In Terraform the `variable` **MUST** be called `resource_group_name`

Scopes will be covered further in the respective language specific specifications.

<br>

---

<br>

#### ID: RMFR4 - Category: Composition - AVM Consistent Feature & Extension Resources Value Add

Resource modules support the following optional features/extension resources, as specified, if supported by the primary resource. The top-level variable/parameter names **MUST** be:

| Optional Features/Extension Resources       | Bicep Parameter Name | Terraform Variable Name | MUST/SHOULD |
|---------------------------------------------|----------------------|-------------------------|-------------|
| Diagnostic Settings                         | `diagnosticSettings` | `diagnostic_settings`   | MUST        |
| Role Assignments                            | `roleAssignments`    | `role_assignments`      | MUST        |
| Resource Locks                              | `lock`               | `lock`                  | MUST        |
| Tags                                        | `tags`               | `tags`                  | MUST        |
| Managed Identities (System / User Assigned) | `managedIdentities`  | `managed_identities`    | MUST        |
| Private Endpoints                           | `privateEndpoints`   | `private_endpoints`     | MUST        |
| Customer Managed Keys                       | `customerManagedKey` | `customer_managed_key`  | MUST        |
| Azure Monitor Alerts                        | `alerts`             | `alerts`                | SHOULD      |

Resource modules **MUST NOT** deploy required/dependent resources for the optional features/extension resources specified above. For example, for Diagnostic Settings the resource module **MUST NOT** deploy the Log Analytics Workspace, this is expected to be already in existence from the perspective of the resource module deployed via another method/module etc.

{{< hint type=note >}}

Please note that the implementation of Customer Managed Keys from an ARM API perspective is different across various RPs that implement Customer Managed Keys in their service. For that reason you may see differences between modules on how Customer Managed Keys are handled and implemented, but functionality will be as expected.

{{< /hint >}}

Module owners **MAY** choose to utilize cross repo dependencies for these "add-on" resources, or **MAY** chose to implement the code directly in their own repo/module. So long as the implementation and outputs are as per the specifications requirements, then this is acceptable.

{{< hint type=tip >}}

Make sure to checkout the language specific specifications for more info on this:

- [Bicep](/Azure-Verified-Modules/specs/bicep#id-bcpnfr1---category-composition---cross-referencing-modules)
- [Terraform](/Azure-Verified-Modules/specs/terraform#id-tfnfr1---category-composition---cross-referencing-modules)

{{< /hint >}}

<br>

---

<br>

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

<br>

---

<br>

#### ID: RMFR8 - Category: Composition - Dependency on child and other resources

A resource module **MAY** contain references to other resource modules, however **MUST NOT** contain references to non-AVM modules nor AVM pattern modules.

See [BCPFR1](/Azure-Verified-Modules/specs/bicep/#id-bcpfr1---category-composition---cross-referencing-modules) and [TFFR1](/Azure-Verified-Modules/specs/terraform/#id-tffr1---category-composition---cross-referencing-modules) for more information on this.

<br>

---

<br>

#### ID: RMFR6 - Category: Inputs - Parameter/Variable Naming

Parameters/variables that pertain to the primary resource **MUST NOT** use the resource type in the name.

e.g., use `sku`, vs. `virtualMachineSku`/`virtualmachine_sku`

Another example for where RPs contain some of their name within a property, leave the property unchanged. E.g. Key Vault has a property called `keySize`, it is fine to leave as this and not remove the `key` part from the property/parameter name.

<br>

---

<br>

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

<br>

---

<br>

### Non-Functional Requirements (RMNFR)

{{< hint type=note >}}
This section includes **resource module level, non-functional requirements (RMNFR)** for Bicep an Terraform.
{{< /hint >}}

---

<br>

#### ID: RMNFR1 - Category: Naming - Module Naming

{{< hint type=note >}}

We will maintain a set of CSV files in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) with the correct singular names for all resource types to enable checks to utilize this list to ensure repos are named correctly. To see the formatted content of these CSV files with additional information, please visit the [AVM Module Indexes](/Azure-Verified-Modules/indexes) page.

This will be updated quarterly, or ad-hoc as new RPs/ Resources are created and highlighted via a check failure.

{{< /hint >}}

Resource modules **MUST** follow the below naming conventions (all lower case):

##### Bicep Resource Module Naming

- Naming convention: `avm/res/<hyphenated resource provider name>/<hyphenated ARM resource type>` (module name for registry)
- Example: `avm/res/compute/virtual-machine` or `avm/res/managed-identity/user-assigned-identity`
- Segments:
  - `res` defines this is a resource module
  - `<hyphenated resource provider name>` is the resource provider’s name after the `Microsoft` part, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute` = `compute`, `Microsoft.ManagedIdentity` = `managed-identity`.
  - `<hyphenated ARM resource type>` is the **singular** version of the word after the resource provider, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute/virtualMachines` = `virtual-machine`, **BUT** `Microsoft.Network/trafficmanagerprofiles` = `trafficmanagerprofile` - since `trafficmanagerprofiles` is all lower case as per the ARM API definition.

##### Terraform Resource Module Naming

- Naming convention:
  - `avm-res-<resource provider>-<ARM resource type>` (module name for registry)
  - `terraform-<provider>-avm-res-<resource provider>-<ARM resource type>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-res-compute-virtualmachine` or `avm-res-managedidentity-userassignedidentity`
- Segments:
  - `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` or `azuread` for resource modules.
  - `res` defines this is a resource module
  - `<resource provider>` is the resource provider’s name after the `Microsoft` part, e.g., `Microsoft.Compute` = `compute`.
  - `<ARM resource type>` is the **singular** version of the word after the resource provider, e.g., `Microsoft.Compute/virtualMachines` = `virtualmachine`

<br>

---

<br>

#### ID: RMNFR2 - Category: Inputs - Parameter/Variable Naming

A resource module **MUST** use the following standard inputs:

- `name` (no default)
- `location` (if supported by the resource and not a global resource, then use Resource Group location, if resource supports Resource Groups, otherwise no default)

<br>

---

<br>

#### ID: RMNFR3 - Category: Composition - RP Collaboration

Module owners (Microsoft FTEs) **SHOULD** reach out to the respective Resource Provider teams to build a partnership and collaboration on the modules creation, existence and long term maintenance.

Review this [wiki page (Microsoft Internal)](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/276/RP-Collaboration) for more information.

<br>

---

<br>
<br>

## Pattern Module Requirements

Listed below are both functional and non-functional requirements for [AVM Pattern Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

<br>

### Functional Requirements (PMFR)

{{< hint type=note >}}
This section includes **pattern module level, functional requirements (PMFR)** for Bicep an Terraform.
{{< /hint >}}

---

<br>

#### ID: PMFR1 - Category: Composition - Resource Group Creation

A Pattern Module **MAY** create Resource Group(s).

<br>

---

<br>

### Non-Functional Requirements (PMNFR)

{{< hint type=note >}}
This section includes **pattern module level, non-functional requirements (PMNFR)** for Bicep an Terraform.
{{< /hint >}}

---

<br>

#### ID: PMNFR1 - Category: Naming - Module Naming

Pattern Modules **MUST** follow the below naming conventions (all lower case):

##### Bicep Pattern Module Naming

- Naming convention: `avm/ptn/<hyphenated grouping/category name>/<hyphenated pattern module name>`
- Example: `avm/ptn/compute/app-tier-vmss` or `avm/ptn/avd-lza/management-plane` or `avm/ptn/3-tier/web-app`
- Segments:
  - `ptn` defines this as a pattern module
  - `<hyphenated grouping/category name>` is a hierarchical grouping of pattern modules by category, with each word separated by dashes, such as:
    - project name, e.g., `avd-lza`,
    - primary resource provider, e.g., `compute` or `network`, or
    - architecture, e.g., `3-tier`
  - `<hyphenated pattern module name>` is a term describing the module’s function, with each word separated by dashes, e.g., `app-tier-vmss` = Application Tier VMSS; `management-plane` = Azure Virtual Desktop Landing Zone Accelerator Management Plane

##### Terraform Pattern Module Naming

- Naming convention:
  - `avm-ptn-<pattern module name>` (Module name for registry)
  - `terraform-<provider>-avm-ptn-<pattern module name>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-ptn-apptiervmss` or `avm-ptn-avd-lza-managementplane`
- Segments:
  - `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` or `azuread` for resource modules.
  - `ptn` defines this as a pattern module
  - `<pattern module name>` is a term describing the module’s function, e.g., `apptiervmss` = Application Tier VMSS; `avd-lza-managementplane` = Azure Virtual Desktop Landing Zone Accelerator Management Plane

<br>

---

<br>

#### ID: PMNFR2 - Category: Composition - Use Resource Modules to Build a Pattern Module

A Pattern Module **SHOULD** be built from AVM Resources Modules to establish a standardized code base and improve maintainability. If a valid reason exists, a pattern module **MAY** contain native resources ("vanilla" code) where it's necessary. A Pattern Module **MUST NOT** contain references to non-AVM modules.

Valid reasons for not using a Resource Module for a resource required by a Pattern Module include but are not limited to:

- When using a Resource Module would result in hitting scaling limitations and/or would reduce the capabilities of the Pattern Module due to the limitations of Azure Resource Manager.
- Developing a Pattern Module under time constraint, without having all required Resource Modules readily available.

{{< hint type=note >}}
In the latter case, the Pattern Module **SHOULD** be updated to use the Resource Module when the required Resource Module becomes available, to avoid accumulating technical debt. Ideally, all required Resource Modules **SHOULD** be developed first, and then leveraged by the Pattern Module.
{{< /hint >}}

<br>

---

<br>

#### ID: PMNFR3 - Category: Composition - Use other Pattern Modules to Build a Pattern Module

A Pattern Module **MAY** contain and be built using other AVM Pattern Modules. A Pattern Module **MUST NOT** contain references to non-AVM modules.

<br>

---

<br>

#### ID: PMNFR4 - Category: Hygiene - Missing Resource Module(s)

An item **MUST** be logged onto as an issue on the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/issues) if a Resource Module does not exist for resources deployed by the pattern module.

{{< hint type=important title=Exception >}}

If the Resource Module adds no value, see Resource Module functional requirement [ID: RMFR2](#id-rmfr2---category-composition---no-resource-wrapper-modules).

{{< /hint >}}

<br>

---

<br>

#### ID: PMNFR5 - Category: Inputs - Parameter/Variable Naming

Parameter/variable input names **SHOULD** contain the resource to which they pertain. E.g., `virtualMachineSku`/`virtualmachine_sku`

<br>

---

<br>
