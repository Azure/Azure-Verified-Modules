---
title: Terraform Owner Contribution Flow
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

This section describes the contribution flow for module owners who are responsible for creating and maintaining Terraform Module repositories.

{{< toc >}}

<br>

---

<br>

{{< hint type=important >}}

This contribution flow is for **Module owners** only.

As a Terraform Module Owner you need to be aware of the [AVM contribution process overview](/Azure-Verified-Modules/contributing/process/,) [shared specifications](/Azure-Verified-Modules/specs/shared/) (including [Interfaces](/Azure-Verified-Modules/specs/shared/interfaces/)) and [Terraform-specific](/Azure-Verified-Modules/specs/terraform/) specifications as as these need to be considered during pull request reviews for the modules you own.

{{< /hint >}}

{{< hint type=info >}}

Make sure module authors/contributors tested their module in their environment before raising a PR. The PR uses e2e checks with 1ES agents in the 1ES subscriptions. At the moment their is no read access to the 1ES susbcription. Also if more than two subscriptions are required for testin, that's currently not supported.

{{< /hint >}}

<br>

---

<br>

### 1. Owner Activities and Responsibilities

<!-- TODO: Add TF Issue Triage once done -->
Familiarise yourself with the responsibilities as **Module Owner** outlined in [Team Definitions & RACI](/Azure-Verified-Modules/specs/shared/team-definitions/#module-owners) and in the [TF Issue Triage](/Azure-Verified-Modules/help-support/issue-triage/).

1. Watch Pull Request (PR) and issue (questions/feedback) activity for your module(s) in your repository and ensure that PRs are reviewed and merged in a timely manner as outlined in [SNFR11](/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times).

{{< hint type=info >}}

Make sure module authors/contributors tested their module in their environment before raising a PR. Also because once a PR is raised a e2e GitHib workflow pipeline is required to be run successfully before the PR can be merged. This is to ensure that the module is working as expected and is compliant with the AVM specifications.

{{< /hint >}}

2. Ensure that the module(s) you own are compliant with the AVM specifications and are working as expected. Following specifications are to be considered and where `Owner` is mentioned explicitly:

| ID | Specification |
|---------------|-----------------------|
| [SFR1](/Azure-Verified-Modules/specs/shared/#id-sfr1---category-composition---preview-services) | Category: Composition - Preview Services |
| [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing) | Category: Testing - E2E Testing |
| [SNFR3](/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-compliance-tests) | Category: Testing - AVM Compliance Tests |
| [SNFR8](/Azure-Verified-Modules/specs/shared/#id-snfr8---category-contributionsupport---module-owners-github) | Category: Contribution/Support - Module Owner(s) GitHub |
| [SNFR11](/Azure-Verified-Modules/specs/shared/#id-snfr11---category-contributionsupport---issues-response-times) | Category: Contribution/Support - Issues Reponse Times |
| [SNFR12](/Azure-Verified-Modules/specs/shared/#id-snfr12---category-contributionsupport---versions-supported) | Category: Contribution/Support - Versions Supported |
| [SNFR17](/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning) | Category: Release - Semantic Versioning |
| [SNFR20](/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) | Category: Contribution/Support - GitHub Teams Only |
| [SNFR21](/Azure-Verified-Modules/specs/shared/#id-snfr21---category-publishing---cross-language-collaboration) | Category: Publishing - Cross Language Collaboration |
| [SNFR24](/Azure-Verified-Modules/specs/shared/#id-snfr24---category-testing---testing-child-extension--interface-resources) | Category: Testing - Testing Child, Extension & Interface Resources |
| [SNFR25](/Azure-Verified-Modules/specs/shared/#id-snfr25---category-composition---resource-naming) | Category: Composition - Resource Naming |
| [RMNFR3](/Azure-Verified-Modules/specs/shared/#id-rmnfr3---category-composition---rp-collaboration) | Category: Composition - RP Collaboration |
| [RMFR4](/Azure-Verified-Modules/specs/shared/#id-rmfr4---category-composition---avm-consistent-feature--extension-resources-value-add) | Category: Composition - AVM Consistent Feature & Extension Resources Value Add |
| [RMFR7](/Azure-Verified-Modules/specs/shared/#id-rmfr7---category-outputs---minimum-required-outputs) | Category: Outputs - Minimum Required Outputs |

<br>

---

<br>

### 2. GitHub Teams and repository creation and configuration

Familiarise yourself with the AVM Resource Module Naming in the [module index csv's](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes).

- Example: `terraform-<provider>-avm-res-<rp>-<ARM resource type>`

{{< hint type=important >}}

Make sure you have access to the Azure organisation see [GitHub Account Link and Access](/Azure-Verified-Modules/contributing/terraform/prerequisites/#github-account-link-and-access).

{{< /hint >}}

1. Create the module repostory using [terraform-azuremrm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template) in the `Azure` organisation with the following [details (internal only)](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review). You will then have to complete the configuration of your repository and start an [internal business review](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review?anchor=conduct-initial-repo-configuration-and-trigger-business-review).

2. Create GitHub teams as outlined in [SNFR20](/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) and add respective parent teams:

Segments:

- `avm-res-<RP>-<modulename>-module-owners-tf`
- `avm-res-<RP>-<modulename>-module-contributors-tf`

Examples:

- `avm-res-compute-virtualmachine-module-owners-tf`
- `avm-res-compute-virtualmachine-module-contributors-tf`


If a secondary owner is required, add the secondary owner to the `avm-res-<RP>-<modulename>-module-owners-tf` team.

1. Add these teams with the following permissions to the repository:

- Admin: `avm-core-team-technical-terraform` = AVM Core Team (Terraform Technical)
- Admin: `terraform-avm` = Terraform PG
- Admin: `avm-res-<RP>-<modulename>-module-owners-tf` = AVM Terraform Module Owners
- Write: `avm-res-<RP>-<modulename>-module-contributors-tf` = AVM Terraform Module Contributors

1. Make sure the branch protection rules for the `main` branch are inherited from the `Azure/terraform-azurerm-avm-template` repository:

- Require a pull request before merging
- Dismiss stale pull request approvals when new commits are pushed
- Require review from Code Owners
- Require linear history
- Do not allow bypassing the above settings

5. Set up a GitHub repository Environment called `test`.

6. Create deployment protection rules for the `test` environment to avoid spinning up e2e tests with every pull request raised by third-parties. Add the following teams as required reviewers:

- AVM Resource Module Owners: `avm-res-<RP>-<modulename>-module-owners-tf`
- AVM Resource Module Contributors: `avm-res-<RP>-<modulename>-module-contributors-tf`
- AVM Core Team Technical (Terraform): `avm-core-team-technical-terraform`

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionTeams.png" alt="Required reviewers." width=100%>

<p>

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionRules.png" alt="Deployment prpotection rules." width=100%>

<p>

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionRules2.png" alt="Deployment prpotection rules." width=100%>

<br>

---

<br>

### 3. GitHub Repository Labels

As per [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) the repositories created by module owners **MUST** have and use the pre-defined GitHub labels. To apply these labels to the repository review the PowerShell script `Set-AvmGitHubLabels.ps1` that is provided in [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels).

```pwsh
Set-AvmGitHubLabels.ps1 -RepositoryName "Azure/MyGitHubRepo" -CreateCsvLabelExports $false -NoUserPrompts $true
```

<br>

---

<br>

### 4. Module Handover Activities

<!-- TODO: Rephrasing required -->
1. Add new owner as maintainer in your `avm-res-<RP>-<modulename>-module-owners-tf` team and remove any other individual including yourself.
2. In case primary owner leaves, switches roles or abandons the repo and the corresponding team then the parent team (if assigned) doesn't have the permissions to gain back access and a ticket with GitHub support needs to be created (but the team can still be removed from the repo since the team `avm-core-team` has permissions on it).

<!-- TODO: Rephrasing required and clarify with team what happens with ORPHANED MODULES
### 5. Orphaned Module Handover Activities


1. In case a module gets a new owner, add the new owner in the `avm-res-<RP>-<modulename>-module-owners-tf` team as `Maintainer` and remove any other individual(s).
2. Remove `ORPHANED.md` from the root directory of the Module.
-->

<br>

---

<br>

### 5. **_Optional_**: Grept

[Grept](https://github.com/Azure/grept) is a linting tool for repositories, ensures predefined standards, maintains codebase consistency, and quality.
It's using the grept configuration files from the [Azure-Verified-Modules-Grept](https://github.com/Azure/Azure-Verified-Modules-Grept) repository.

You can see [here](https://github.com/Azure/Azure-Verified-Modules-Grept/blob/main/terraform/synced_files.grept.hcl) which files are synced from the [`terraform-azurerm-avm-template`](https://github.com/Azure/terraform-azurerm-avm-template) repository.

{{< hint type=info >}}

You don't need to run grept manaully because it will be executed with the help of a [cron job](https://github.com/Azure/Azure-Verified-Modules-Grept/actions/workflows/grept-cronjob.yml) on a weekly basis to ensure consistency across all AVM Terraform Module repositories. In case your repository is in an inconsistent state it will create necessary PRs which needs to be approved and merged by you, the owner. However, you can also run it manually with the help of `./avm` to check if your module is compliant with the grept rules.

{{< /hint >}}

1. Set environment variables

```bash
# Linux/MacOS
export GITHUB_REPOSITORY_OWNER=Azure
export GITHUB_REPOSITORY=Azure/terraform-azurerm-avm-res-<RP>-<modulename>"

# Windows

$env:GITHUB_REPOSITORY_OWNER="Azure"
$env:GITHUB_REPOSITORY="Azure/terraform-azurerm-avm-res-<RP>-<modulename>"
```

1. Run grept

```bash
# Linux/MacOS
./avm grept-apply

# Windows
avm.bat grept-apply
```

### 6. Publish the module

Once a module was updated and is ready to be published, follow the below steps to publish the module to the HashiCorp Registry.

Ensure your module is ready for publishing:

1. All tests are passing.
2. All examples are passing.
3. All documentation is generated.
4. Include/Add [`avm-core-team-technical-terraform`](https://github.com/orgs/Azure/teams/avm-core-team-technical/members) as a reviewer (if not added automatically added already).
5. Create a tag for the module version you want to publish.
- Create tag: `git tag -a 0.1.0 -m "0.1.0"`
- Push tag: `git push`
- [Create a release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository) on Github based on the tag you just created. Make sure to generate the release notes using the `Generate release notes` button.
- **_Optional:_** Instead of creating the tag via git cli, you can also create both the tag and release via [Github UI](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository). Just go to the releases tab and click on `Draft a new release`. Make sure to create the tag from the `main` branch.

<img src="/Azure-Verified-Modules/img/contribution/gitTag.png" alt="Deployment prpotection rules." width=100%>

6. Elevate your respository access using the Open Source Management Portal (aka.ms/opensource/portal).
7. Sign in to the [HashiCorp Registry](https://registry.terraform.io/) using GitHub.
8. Publish a module by selecting the `Publish` button in the top right corner, then `Module`
9. Select the repository and accept the terms.

{{< hint type=info >}}

Once a module gets updated and becomes a new version/release it will be automatically published with the latest published release version to the HashiCorp Registry.

{{< /hint >}}

{{< hint type=important >}}

When an AVM Module is published to the HashiCorp Registry, it **MUST** follow the below requirements:

- Resource Module: `terraform-<provider>-avm-res-<rp>-<ARM resource type>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `terraform-<provider>-avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

{{< /hint >}}

<br>

---

<br>
