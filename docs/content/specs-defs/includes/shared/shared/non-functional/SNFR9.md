---
title: SNFR9 - AVM & PG Teams GitHub Repo Permissions
url: /spec/SNFR9
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Contribution/Support,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-Initial
]
priority: 120
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
