This section describes the contribution flow for module owners who are responsible for creating and maintaining Terraform Module repositories.

- [1. GitHub repository creation and configuration](#1-github-repository-creation-and-configuration)
- [2. GitHub Repository Labels](#2-github-repository-labels)
- [3. **_Optional_**: Grept](#3-optional-grept)
- [4. Publish the module](#4-publish-the-module)

<br>

---

<br>

{{< hint type=important >}}

This contribution flow is for **Module owners** only.

As a Terraform Module Owner you need to be aware of the [AVM contribution process overview](https://azure.github.io/Azure-Verified-Modules/contributing/process/,) [shared specifications](https://azure.github.io/Azure-Verified-Modules/specs/shared/) (including [Interfaces](https://azure.github.io/Azure-Verified-Modules/specs/shared/interfaces/)) and [Terraform-specific](https://azure.github.io/Azure-Verified-Modules/specs/terraform/) specifications as as these need to be considered during pull request reviews for the modules you own.

{{< /hint >}}

{{< hint type=info >}}

Make sure module authors/contributors tested their module in their environment before raising a PR. The PR uses e2e checks with 1ES agents in the 1ES subscriptions. At the moment their is no read access to the 1ES susbcription. Also if more than two subscriptions are required for testin, that's currently not supported.

{{< /hint >}}

<br>

---

<br>

### 1. GitHub repository creation and configuration

Familiarise yourself with the AVM Resource Module Naming in the [module index csv's](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes).

- Example: `terraform-<provider>-avm-res-<rp>-<ARM resource type>`

1. Create GitHub teams:

- `@Azure/avm-res-<RP>-<modulename>-module-owners-tf`
- `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf`

2. Create the module repostory using [terraform-azuremrm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template) in the `Azure` organisation with the following [details (internal only)](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review). You will then have to complete the configuration of your repository and start an [internal business review](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review?anchor=conduct-initial-repo-configuration-and-trigger-business-review).

3. Update the README.md with the appropriate title and any additional description required. This is not accounted for in the `pre-check` package. 

4. Add these teams with the following permissions to the repository:

- Admin: `@Azure/avm-core-team-technical-terraform` = AVM Core Team (Terraform Technical)
- Admin: `@Azure/terraform-avm` = Terraform PG
- Admin: `@Azure/avm-res-<RP>-<modulename>-module-owners-tf` = AVM Terraform Module Owners
- Write: `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf` = AVM Terraform Module Contributors

1. Make sure the branch protection rules for the `main` branch are inherited from the `Azure/terraform-azurerm-avm-template` repository:

- Require a pull request before merging
- Dismiss stale pull request approvals when new commits are pushed
- Require review from Code Owners
- Require linear history
- Do not allow bypassing the above settings

5. Set up a GitHub repository Environment called `test`.

6. Create deployment protection rules for the `test` environment to avoid spinning up e2e tests with every pull request raised by third-parties. Add the following teams as required reviewers:

- AVM Resource Module Owners: `@Azure/avm-res-<RP>-<modulename>-module-owners-tf`
- AVM Resource Module Contributors: `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf`
- AVM Core Team Technical (Terraform): `@Azure/avm-core-team-technical-terraform`

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionTeams.png" alt="Required reviewers." width=100%>

<p>

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionRules.png" alt="Deployment prpotection rules." width=100%>

<p>

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionRules2.png" alt="Deployment prpotection rules." width=100%>

<br>

---

<br>

### 2. GitHub Repository Labels

As per [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) the repositories created by module owners **MUST** have and use the pre-defined GitHub labels. To apply these labels to the repository review the PowerShell script `Set-AvmGitHubLabels.ps1` that is provided in [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels).

```pwsh
Set-AvmGitHubLabels.ps1 -RepositoryName "Azure/MyGitHubRepo" -CreateCsvLabelExports $false -NoUserPrompts $true
```

<br>

---

<br>

### 3. **_Optional_**: Grept

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

### 4. Publish the module

Once a module was updated and is ready to be published, follow the below steps to publish the module to the HashiCorp Registry.

Ensure your module is ready for publishing:

1. All tests are passing.
2. All examples are passing.
3. All documentation is generated.
4. Include/Add [`@Azure/avm-core-team-technical-terraform`](https://github.com/orgs/Azure/teams/avm-core-team-technical-terraform) as a reviewer (if not added automatically added already).
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

{{< hint type=important >}}

When an AVM Module is published to the HashiCorp Registry, it **MUST** follow the below requirements:

- Resource Module: `terraform-<provider>-avm-res-<rp>-<ARM resource type>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `terraform-<provider>-avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

{{< /hint >}}

<br>

---

<br>
