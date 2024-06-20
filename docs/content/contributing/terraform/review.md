---
title: Initial Review of Terraform Modules
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

The initial AVM module review is a critical step before an AVM terraform module gets published to the [Terraform Registry](https://registry.terraform.io/) and made publicly available for customers, partners and wider IaC community to consume and contribute to. It serves as a quality assurance step to ensure that the AVM terraform module complies with the [shared](https://azure.github.io/Azure-Verified-Modules/specs/shared/) and [terraform](https://azure.github.io/Azure-Verified-Modules/specs/terraform/) specifications of AVM. The below process outlines the steps that both the module owner and module reviewer need to follow.

1. The module owner completes the development of the module in their branch or fork.

2. The module owner submits a pull request (PR) titled 'AVM-Review-PR' and ensures that all checks are passing on that PR as that is a pre-requisite to request a review.

3. The module owner assigns the `avm-core-team-technical-terraform` GitHub team as reviewer on the PR.

4. The module owner leaves the following comment as is on the module proposal in the [AVM Repo](https://aka.ms/avm/moduleproposals) by searching for their module proposal issue there.

{{< expand "➕ AVM Terraform Module Review Request" "expand/collapse" >}}

```I would like to request a review of my module. The latest code is in a PR titled AVM-Review-PR on the module repo and all checks on that PR are passing.```

{{< /expand >}}

6. The AVM team moves the module proposal from "In Development" to "In Review" in the [AVM - Module Triage](https://github.com/orgs/Azure/projects/529) project.

7. The AVM team will assign a module reviewer who will open a blank issue on the module titled "AVM-Review" and populate it with the below mark down. This template already marks the specs as compliant which are covered by the checks that run on the PR. There are some specs which don't need to be checked at the time of publishing the module therefore they are marked as NA.

{{< expand "➕ AVM Terraform Module Review Issue" "expand/collapse" >}}

{{< include file="static/includes/avm-terraform-module-review-template.md" language="markdown" options="linenos=false" >}}

{{< /expand >}}

7. The module reviewer can update the Compliance column for specs in line 42 to 47 to `NA`, in case the module being reviewed isn't a pattern module.

8. The module reviewer reviews the code in the PR and leaves comments to request any necessary updates.

9. The module reviewer assigns the AVM-Review issue to the module owner and responds to the module owner's comment on the Module Proposal in AVM Repo with the following

{{< expand "➕ AVM Terraform Module Review Initiation Message" "expand/collapse" >}}

```Thank you for requesting a review of your module. The AVM module review process has been initiated, please perform the **Requested Actions** on the AVM-Review issue on the module repo.```

{{< /expand >}}

10. The module owner updates the check list and the table in the AVM-Review issue and notifies the module reviewer in a comment.

11. The module reviewer performs the final review and ensures that all checks in the checklist are complete and the specifications table has been updated with no requirements having compliance as 'No'.

12. The module reviewer approves the AVM-Review-PR, and closes the AVM-Review issue with the following comment.

{{< expand "➕ AVM Terraform Module Review Completion Message" "expand/collapse" >}}
<!-- markdownlint-disable -->
Thank you for contributing this module and completing the review process per AVM specs to ensure quality.

You may proceed with publishing this module to the HashiCorp Terraform Registry with the initial pre-release version of v0.1.0.

Please keep future versions also pre-release (e.g., 0.1.0, 0.1.1, 0.2.0, etc.) until AVM becomes generally available (GA) of which the AVM team will notify you.

**Requested Action**: Once the module is published to the HashiCorp Terraform Registry, please update the module proposal issue with the below comment.

The initial review of this module is complete and the module has been published to the registry. Requesting AVM team to close this module proposal and mark the module available in the module index.

{{< /expand >}}

13. The module owner merges the AVM-Review-PR, publishes the module to Terraform registry and updates the module proposal on the AVM repo with the following comment.

{{< expand "➕ AVM Terraform Module Publish Message" "expand/collapse" >}}

```The initial review of this module is complete and the module has been published to the registry. Requesting AVM team to close this module proposal and mark the module available in the module index.```

{{< /expand >}}

14. The module reviewer updates the module proposal by performing the following steps:
- Move the module proposal from "In Review" to "Done" in the [AVM - Module Triage](https://github.com/orgs/Azure/projects/529) project.
- Assign label Status: Module Available :green_circle:
- Update the module index
- Close the module proposal
