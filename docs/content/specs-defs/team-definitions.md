---
title: Team Definitions & RACI
url: /specs/shared/team-definitions/
description: Team Definitions & RACI for the Azure Verified Modules (AVM) program
---

## Teams

In AVM there will be multiple different teams involved throughout the initiatives lifecycle and ongoing long-term support. These teams will be listed below alongside their definitions.

{{% notice style="important" %}}

Individuals can be members of multiple teams, at once, that are defined below.

{{% /notice %}}

### AVM Core Team

GitHub Team: [`@Azure/avm-core-team`](https://github.com/orgs/Azure/teams/avm-core-team)

The AVM core team are responsible for:

1. **Managing the AVM Solution**: Leading and managing AVM from a technical standpoint, ensuring the maintenance and growth of the Public Bicep Registry's repository and the Terraform Registry. Governing the lifecycle and support SLAs for all AVM modules, as well as providing overall governance and overseeing/facilitating the contribution process.
2. **Testing and quality enforcement**: Developing, operating and enforcing the test framework and related tooling with all its quality gates. Providing initial reviews for all modules, making sure all standards are met.
3. **Documentation**: Defining and refining principles, contribution and consumption guidelines, specifications and procedures related to AVM modules, maintaining and publishing all related documentation on the program's public website.
4. **Community Engagement**: Organizing internal and external events, such as hackathons, office hours, community calls and training events for current and future module owners and contributors. Presenting in live events both publicly and internally; publishing blog posts and videos on YouTube, etc.
5. **Security Enhancements**: Facilitating the implementation and/or implementing security enhancements across all AVM repositories - through the WAF (Well-Architected Framework) framework.
6. **Supporting Module Owners**: Providing day-to-day support for module owners, helping troubleshoot and manage security fixes for orphaned modules.
7. **Improving Processes and Gathering Insights**: Improving automation for issue triage and management processes and lead the development of internal dashboards to gain insights into contribution and consumption metrics.
8. **Undefined tasks**: Anything else not defined below for another team or in the RACI 👍

The team includes both technical and non-technical team members who are all Microsoft FTEs.

### Module Owners

{{% notice style="important" %}}

Today, module owners **MUST** be Microsoft FTEs. This is to ensure that within AVM the long-term support for each module can be upheld and honoured.

{{% /notice %}}

Module owners are responsible for:

1. **Initial module development**
2. **Module Maintenance (proactive & reactive)**
    - Regular updates to ensure compatibility with the latest Azure services (including supporting new API versions and referencing the newest AVM modules when applicable).
    - WAF Reliability & Security alignment
    - Bug fixes, security patches and feature improvements.
    - Ensuring long term compliance with AVM specifications
    - Implementing and improving automated testing and validation tools for new modules.
    - Improving documentation through rich examples.
3. **Ongoing module support**
    - Module Issue/Pull Request Triage & Resolution
    - Module Feature Request Triage & Additions
4. **Managing additional module contributors**

Ideally there **SHOULD** be at least 2 module owners per module who **MUST** be added to a [GitHub Team in the `Azure` organization.]({{%siteparam base%}}/spec/SNFR20/)

### Module Contributors

{{% notice style="important" %}}

Module Contributors can be anyone in any organization. However, they must be an active contributor and supporting the Module Owners.

{{% /notice %}}

Module Contributors are responsible for:

- Assisting the Module Owners with their responsibilities

Module Contributors **MUST** be added to a separate [GitHub Team in the `Azure` organization]({{%siteparam base%}}/spec/SNFR20/) that the Module Owners manage and are maintainers of.

### Product Groups

GitHub Teams:

- [`@Azure/bicep-admins`](https://github.com/orgs/Azure/teams/bicep-admins) = Bicep PG team
- [`@Azure/terraform-avm`](https://github.com/orgs/Azure/teams/terraform-avm) = Azure Terraform PG

The Azure Bicep & Terraform Product Groups are responsible for:

- Backup/Additional support for orphaned modules to the AVM Core Team
- Providing inputs and feedback on AVM
- Taking on feedback and feature requests on their products, Bicep & Terraform, from AVM usage

{{% notice style="note" %}}

We are investigating working with all Azure Product Groups as a future investment area that they take on ownership, or contribute to, the AVM modules for their service/product.

{{% /notice %}}

## RACI

{{% notice style="note" title="RACI Definition" %}}

**R = Responsible** – Those who do the work to complete the task/responsibility.

**A = Accountable** – The one answerable for the correct and thorough completion of the task. There must be only one accountable person per task/responsibility. Typically has 'sign-off'.

**C = Consulted** – Those whose opinions are sought.

**I = Informed** – Those who are kept up to date on progress.

{{% /notice %}}

The below table defines a RACI to be adopted by all parties referenced in the table to ensure customers can trust these modules and can consume and contribute to the initiative at scale.

| Action/Task/Responsibility                                                                       | Module Owners | Module Contributors | AVM Core Team | Product Groups | Notes |
| ------------------------------------------------------------------------------------------------ | ------------- | ------------------- | ------------- | -------------- | ----- |
| Build/Construct an AVM Module                                                                    | R, A          | R, C                | C, I          | I              |       |
| Publish a Bicep AVM Module to the Bicep Public Registry                                          | R, A          | C, I                | C, I          | I              |       |
| Publish a Terraform AVM Module to the Terraform Registry                                         | R, A          | C, I                | C, I          | I              |       |
| Manage and maintain tooling/testing frameworks pertaining to module quality                      | C, I          | C, I                | R, A          | C, I           |       |
| Manage/run the AVM central backlog (module proposals, orphaned modules, test enhancements, etc.) | C, I          | C, I                | R, A          | C, I           |       |
| Provide day-to-day (BAU) module support                                                          | R, A          | R, C                | I             | I              |       |
| Provide security fixes for orphaned modules                                                      | N/A           | N/A                 | R, A          | R, C, I        |       |
