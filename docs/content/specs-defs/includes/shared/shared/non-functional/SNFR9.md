---
title: SNFR9 - AVM & PG Teams GitHub Repo Permissions
url: /spec/SNFR9
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
  Validation-TBD # SINGLE VALUE: this can be "Validation-Manual" OR "Validation-CI/Informational" OR "CI/Enforced"
]
priority: 1120
---

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
