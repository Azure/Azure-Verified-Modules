---
title: SNFR20 - GitHub Teams Only
url: /spec/SNFR20
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Contribution/Support, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1110
---

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
  - See [RMNFR1](/Azure-Verified-Modules/spec/RMNFR1) for AVM Resource Module Naming
  - See [PMNFR1](/Azure-Verified-Modules/spec/PMNFR1) for AVM Pattern Module Naming
- `module-owners` or `module-contributors` == the role the GitHub Team is assigned to
- `<bicep/tf>` == the language the module is written in

Examples:

- `avm-res-compute-virtualmachine-module-owners-bicep`
- `avm-res-compute-virtualmachine-module-contributors-tf`

<br>

##### Add Team Members

All officially documented module owner(s) **MUST** be added to the `-module-owners-` team. The `-module-owners-` team **MUST NOT** have any other members.

Any additional module contributors whom the module owner(s) agreed to work with **MUST** be added to the `-module-contributors-` team.

Unless explicitly requested and agreed, members of the AVM core team or any PG teams **MUST NOT** be added to the `-module-owners-` or `-module-contributors-` teams as permissions for them are granted through the teams described in [SNFR9](/Azure-Verified-Modules/spec/SNFR9).

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
- The GitHub team of the AVM Bicep reviewers, with the `@Azure/` prefix, i.e., `@Azure/avm-module-reviewers-bicep`

Example - `CODEOWNERS` entry for the Bicep resource module of Azure Virtual Network (`avm/res/network/virtual-network`):

- `/avm/res/network/virtual-network/ @Azure/avm-res-network-virtualnetwork-module-owners-bicep @Azure/avm-module-reviewers-bicep`

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
