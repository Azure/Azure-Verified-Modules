---
title: Review of Terraform Modules
linktitle: Review
description: Terraform Module Review Process for the Azure Verified Modules (AVM) program
---


The AVM module review is a critical step before an AVM Terraform module gets published to the [Terraform Registry](https://registry.terraform.io/) and made publicly available for customers, partners and wider community to consume and contribute to. It serves as a quality assurance step to ensure that the AVM Terraform module complies with the [Terraform specifications]({{% siteparam base %}}/specs/tf/) of AVM. The below process outlines the steps that both the module owner and module reviewer need to follow.

1. The module owner completes the development of the module in their branch or fork.

2. The module owner submits a pull request (PR) titled `AVM-Review-PR` and ensures that all checks are passing on that PR as that is a pre-requisite to request a review.

3. The module owner assigns the `avm-core-team-technical-terraform` GitHub team as reviewer on the PR.

4. The module owner leaves the following comment as it is on the module proposal in the [AVM - Module Triage](https://github.com/orgs/Azure/projects/529) project by searching for their module proposal by name there.

    {{% expand title="➕ AVM Terraform Module Review Request" %}}

{{< highlight lineNos="false" type="markdown" wrap="true" title="" >}}

I have completed my initial development of the module and I would like to request a review of my module before publishing it to the Terraform Registry. The latest code is in a PR titled [AVM-Review-PR](REPLACE WITH URL TO YOUR PR) on the module repo and all checks on that PR are passing.

{{< /highlight >}}

{{% /expand %}}

5. The AVM team moves the module proposal from "In Development" to "In Review" in the [AVM - Module Triage](https://github.com/orgs/Azure/projects/529) project.

6. The AVM team will assign a module reviewer who will open a blank issue on the module titled "AVM-Review" and populate it with the below mark down. This template already marks the specs as compliant which are covered by the checks that run on the PR. There are some specs which don't need to be checked at the time of publishing the module therefore they are marked as NA.

    {{% expand title="➕ AVM Terraform Module Review Issue" %}}

{{% include file="static/includes/avm-terraform-module-review-template.md" %}}

{{% /expand %}}

7. The module reviewer can update the Compliance column for specs in line 42 to 47 to `NA`, in case the module being reviewed isn't a pattern module.

8. The module reviewer reviews the code in the PR and leaves comments to request any necessary updates.

9. The module reviewer assigns the AVM-Review issue to the module owner and links the AVM-Review Issue to the AVM-Review-PR so that once the module reviewer approves the PR and the module owner merges the AVM-Review-PR, the AMV-Review issue is automatically closed. The module reviews responds to the module owner's comment on the Module Proposal in AVM Repo with the following

    {{% expand title="➕ AVM Terraform Module Review Initiation Message" %}}

{{< highlight lineNos="false" type="markdown" wrap="true" title="" >}}

Thank you for requesting a review of your module. The AVM module review process has been initiated, please perform the **Requested Actions** on the AVM-Review issue on the module repo.

{{< /highlight >}}

{{% /expand %}}

10. The module owner updates the check list and the table in the AVM-Review issue and notifies the module reviewer in a comment.

11. The module reviewer performs the final review and ensures that all checks in the checklist are complete and the specifications table has been updated with no requirements having compliance as 'No'.

12. The module reviewer approves the AVM-Review-PR, and leaves the following comment on the AVM-Review issue with the following comment.

    {{% expand title="➕ AVM Terraform Module Review Completion Message" %}}

{{< highlight lineNos="false" type="markdown" wrap="true" title="" >}}

Thank you for contributing this module and completing the review process per AVM specs. The AVM-Review-PR has been approved and once you merge it that will close this AVM-Review issue. You may proceed with [publishing]({{% siteparam base %}}/contributing/terraform/terraform-contribution-flow/owner-contribution-flow/#7-publish-the-module) this module to the HashiCorp Terraform Registry with an initial pre-release version of v0.1.0. Please keep future versions also pre-release i.e. < 1.0.0 until AVM becomes generally available (GA) of which the AVM team will notify you.

**Requested Action**: Once published please update your [module proposal](REPLACE WITH THE LINK TO THE MODULE PROPOSAL) with the following comment.

"The initial review of this module is complete, and the module has been published to the registry. Requesting AVM team to close this module proposal and mark the module available in the module index.
Terraform Registry Link: <REPLACE WITH THE LINK OF THE MODULE IN TERRAFORM REGISTRY>
GitHub Repo Link: <REPLACE WITH THE LINK OF THE MODULE IN GITHUB>"

{{< /highlight >}}

{{% /expand %}}

13. Once the module owner perform the requested action in the previous step, the module reviewer updates the module proposal by performing the following steps:

- Assign label Status: Module Available :green_circle: to the module proposal.
- Update the module index excel file and CSV file by creating a PR to update the module index and links the module proposal as an issue that gets closed once the PR is merged which will move the module proposal from "In Review" to "Done" in the [AVM - Module Triage](https://github.com/orgs/Azure/projects/529) project.
