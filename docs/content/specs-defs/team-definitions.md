---
title: Team Definitions & RACI
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/shared/team-definitions/
---
{{< toc >}}

## Teams
In AVM there will be multiple different teams involved throughout the initiatives lifecycle and ongoing long-term support. These teams will be listed below alongside their definitions.

{{< hint type=important >}}

Individuals can be members of multiple teams, at once, that are defined below.

{{< /hint >}}

<br>

### AVM Core Team

GitHub Team: [`@Azure/avm-core-team`](https://github.com/orgs/Azure/teams/avm-core-team)

The AVM core team are responsible for:

- Specifications
  - Shared
  - Language Specific
- Contribution Guidance
- Test Frameworks & Tooling
- Initiative Governance
  - Module Lifecycle
  - Test Enforcement
  - Module Support SLAs
- Anything else not defined below for another team or in the RACI 👍

The team is made up of both technical and non-technical team members that are all Microsoft FTEs.

<br>

### Module Owners

{{< hint type=important >}}

Today, module owners **MUST** be Microsoft FTEs. This is to ensure that within AVM the long-term support for each module can be upheld and honoured.

{{< /hint >}}

Module owners are responsible for:

- Module Creation
- Module Maintenance (proactive & reactive)
- Module Issue/Pull Request Triage & Resolution
- Module Feature Request Triage & Additions
- Managing Module Contributors

Ideally there **SHOULD** be at least 2 module owners per module and **MUST** be in a [GitHub Team in the `Azure` organization.](https://github.com/orgs/Azure/teams/)

<br>

### Module Contributors

{{< hint type=important >}}

Module Contributors can be anyone in any organization. However, they must be an active contributor and supporting the Module Owners.

{{< /hint >}}

Module Contributors are responsible for:

- Assisting the Module Owners with their responsibilities

Module Contributors **MUST** be in a separate [GitHub Team in the `Azure` organization](https://github.com/orgs/Azure/teams/), that the Module Owners manage and are maintainers of.

<br>

### Product Groups

GitHub Teams:

- [`@Azure/bicep-admins`](https://github.com/orgs/Azure/teams/bicep-admins) = Bicep PG team
- [`@Azure/terraform-avm`](https://github.com/orgs/Azure/teams/terraform-avm) = Azure Terraform PG

The Azure Bicep & Terraform Product Groups are responsible for:

- Backup/Additional support for orphaned modules to the AVM Core Team
- Providing inputs and feedback on AVM
- Taking on feedback and feature requests on their products, Bicep & Terraform, from AVM usage

{{< hint type=note >}}

We are investigating working with all Azure Product Groups as a future investment area that they take on ownership, or contribute to, the AVM modules for their service/product.

{{< /hint >}}

<br>

## RACI

{{< hint type=note title="RACI Definition" >}}

**R = Responsible** – Those who do the work to complete the task/responsibility.

**A = Accountable** – The one answerable for the correct and thorough completion of the task. There must be only one accountable person per task/responsibility. Typically has 'sign-off'.

**C = Consulted** – Those whose opinions are sought.

**I = Informed** – Those who are kept up to date on progress.

{{< /hint >}}

The below table defines a RACI that is proposed to be adopted by AVM and all parties referenced in the table. This will give consumers faith and trust in these modules so that they can consume and contribute to the initiative at scale.

| Action/Task/Responsibility                                                                       | Module Owners | Module Contributors | AVM Core Team | Product Groups | Notes |
| ------------------------------------------------------------------------------------------------ | ------------- | ------------------- | ------------- | -------------- | ----- |
| Build/Construct an AVM Module                                                                    | R, A          | R, C                | C, I          | I              |       |
| Publish a Bicep AVM Module to the Bicep Public Registry                                          | R, A          | C, I                | C, I          | I              |       |
| Publish a Terraform AVM Module to the Terraform Registry                                         | R, A          | C, I                | C, I          | I              |       |
| Manage and maintain tooling/testing frameworks pertaining to module quality                      | C, I          | C, I                | R, A          | C, I           |       |
| Manage/run the AVM central backlog (module proposals, orphaned modules, test enhancements, etc.) | C, I          | C, I                | R, A          | C, I           |       |
| Provide day-to-day (BAU) module support                                                          | R, A          | R, C                | I             | I              |       |
| Provide security fixes for orphaned modules                                                      | N/A           | N/A                 | R, A          | R, C, I        |       |
