# AVM Review of Terraform Modules

## New Module Review
AVM Review is a critical step before an AVM terraform module is published to terraform registry and made publicly available for customers, partners and wider IaC community to consume and contribute to. It acts as a quality assurance step to ensure that the AVM terraform module complies with the shared and terraform specifications of AVM. The below process outlines the steps for both a module owner and a module reviewer to follow to do an AVM Review of a terraform module.

1. The module owner completes the development of the module in their branch or fork.

2. The module owner does a pull request (PR) titled 'AVM-Review-PR' ensuring that all checks are passing on that PR as that is a pre-requisite to request a review.

3. The module owner assigns the `avm-core-team-technical-terraform` as reviewers on the PR.
<br><img src="/Azure-Verified-Modules/img/contribution/avm-reviewer.png" alt="Request Review" width=25%>

4. The module owner leaves the following comment as is on the module proposal in the AVM Repo by searching for their module proposal here.
<br>"I would like to request a review of my module. The latest code is in a PR titled AVM-Review-PR on the module repo and all checks on that PR are passing."

5. The above comment will help move the module proposal from "In Development" to "In Review".

6. The `avm-core-team-technical-terraform` team will be notified and will assign a module reviewer.

7. The module reviewer respond to the module owner's comment with the following comment as is on the module proposal in the AVM Repo.
<br>"I have been assigned as the module reviewer and will be helping with reviewing this module."

8. The module reviewer will open a blank issue on the module titled "AVM-Review" and populate it with the below mark down. This template already marks the specs as compliant which are covered by the checks that run on the PR. There are some specs which don't need to be checked at the time of publishing the module therefore they are marked as NA.

{{< expand "➕ AVM Terraform Module Review Template" "expand/collapse" >}}

{{< include file="static/includes/avm-terraform-module-review-template.md" language="markdown" options="linenos=false" >}}

{{< /expand >}}

9. The module reviewer can update the Compliance column for specs 42 to 47 to NA in case the module being reviewed isn't a pattern module.

10. The module reviewer to review the code in the PR and make comments on anything that doesn't look right to the module reviewer.

11.

## Existing Module Review
