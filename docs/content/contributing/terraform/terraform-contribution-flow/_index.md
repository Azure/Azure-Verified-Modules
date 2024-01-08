---
title: Terraform Contribution Flow
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

## High-level contribution flow

{{< mermaid class="text-center" >}}
flowchart TD
A(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#1-setup-your-azure-test-environment'>1. Setup your Azure test environment </a>)
B(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#1-setup-your-azure-test-environment'>2. Fork the module source repository</a>)
C(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#3-configure-your-ci-environment'>3. Configure CI environment </a> <br> For module tests)
D(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#4-implement-your-contribution'>4. Implementing your contribution </a><br> Refer to Gitflow Diagram below)
E{<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#5-createupdate-and-run-tests'>5. Workflow test <br> completed <br> successfully?</a>}
F(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#6-create-a-pull-request-to-the-public-bicep-registry'>6. Create a pull request to the upstream repository</a>)
A --> B
B --> C
C --> D
D --> E
E -->|yes|F
E -->|no|D
{{< /mermaid >}}

<br>

---

<br>

<!--
TODO: Adjust GitFlow diagram for TF contributors

## GitFlow for contributors

The GitFlow process outlined here introduces a central anchor branch. This branch should be treated as if it were a protected branch. It serves to synchronize the forked repository with the original upstream repository. The use of the anchor branch is designed to give contributors the flexibility to work on several modules simultaneous.
{{< mermaid class="text-center" >}}
%%{init: { 'logLevel': 'debug', 'gitGraph': {'rotateCommitLabel': false}} }%%
gitGraph LR:
commit id:"Fork Repo"
branch anchor
checkout anchor
commit id:"Sync Upstream/main" type: HIGHLIGHT
branch avm-type-provider-resource-workflow
checkout avm-type-provider-resource-workflow
commit id:"Add Workflow File for Resource/Pattern"
branch avm-type-provider-resource
checkout main
merge avm-type-provider-resource-workflow id: "merge workflow for GitHub Actions Testing" type: HIGHLIGHT
checkout avm-type-provider-resource
commit id:"Init"
commit id:"Patch 1"
commit id:"Patch 2"
checkout main
merge avm-type-provider-resource
{{< /mermaid >}}

{{< hint type=tip >}}

When implementing the GitFlow process as described, it is advisable to configure the local clone with a remote for the upstream repository. This will enable the Git CLI and local IDE to merge changes directly from the upstream repository. Using GitHub Desktop, this is configured automatically when cloning the forked repository via the application.

{{< /hint >}}

<br>

---

<br>
-->

<!--
TODO:

Checklist

Run grept
Update provider versions
cd root
avmfix -folder . # examples too
make fmt
make docs

-->

{{< hint type=note >}}

Each time in the following sections we refer to 'your xzy', it is an indicator that you have to change something in your own environment.

{{< /hint >}}

# Prepare your developer environment

- [1. Setup your GitHub repository](#1-setup-your-github-repository)

## 1. Setup your GitHub repository

1. Set up a GitHub repository environment called `test`.
2. Configure an environment protection rule to ensure that approval is required before deploying to the `test` environment.
<!-- TODO: secrets can be removed since the latest azteraform docker image with having ./avm implemented -->
3. Create the following environment secrets on the `test` environment:
   1. `AZURE_CLIENT_ID`
   2. `AZURE_TENANT_ID`
   3. `AZURE_SUBSCRIPTION_ID`

## 2. Setup your Azure test environment

AVM tests the deployments in an Azure subscription. To do so, it requires a service principal with access to it.

In this first step, make sure you

1. Create a user-assigned managed identity in your test subscription.
2. Create a role assignment for the managed identity on your test subscription, use `Contributor` role (your module might require higher privileges).
3. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.

<br>

---

<br>

## 3. Fork the Module source repository

{{< hint type=important >}}

Each Terraform AVM module will have its own GitHub Repository in the [`Azure`](https://github.com/Azure) GitHub Organization as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

This repo will be created by the Module Owners and the AVM Core team collaboratively, including the configuration of permissions as per [SNFR9](/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions)

{{< /hint >}}

Module contributors are expected to fork the corresponding repository and work on a branch from within their fork, before then creating a Pull Request (PR) back into the repository's `main` branch.

To do so, simply navigate to your desired repository, select the `'Fork'` button to the top right of the UI, select where the fork should be created (i.e., the owning organization) and finally click 'Create fork'.

{{< hint type=important >}}

If the module repository you want to contribute to is not yet available, please get in touch with the respective module owner which can be tracked in the [Terraform Resource Modules index](https://azure.github.io/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/) see `PrimaryModuleOwnerGHHandle` column.

{{< /hint >}}

<br>

---

<br>

## 4. Configure your CI environment

1. Download `azterraform` Docker image

### 3.1. Set up environment variables

### 3.2. Download `azterraform` Docker image

{{< hint type=important >}}

Make sure you have **Docker** installed on your machine.

{{< /hint >}}

{{< /hint >}}

<br>

---

<br>

## 4. Implement your contribution

1. Search and update TODOs within the code and remove the TODO comments once complete.

<br>

---

<br>

## 5. Run checks

- [5.1 Check Terraform code](#51-check-terraform-code)
- [5.2 Check Pipeline requirements](#52-check-pipeline-requirements)
- [5.3 Run grept](#53-run-e2e-tests)
- [5.4 Run e2e tests](#54-run-e2e-tests)
- [5.5 Install 1ES](#55-install-1es)

### 5.1. Check Terraform code

### 5.2. Check Pipeline requirements

### 5.3 Run grept

### 5.4 Run e2e tests

### 5.5 Install 1ES

<br>

---

<br>

## 6. Create a pull request to the upstream repository.

<br>

---

<br>

## Owner contribution flow

<!-- TODO:
- Add the creation of 1ES pool
>

1. As a Terraform Module Owner you need to be aware of the [AVM contribution process overview](https://azure.github.io/Azure-Verified-Modules/contributing/process/,) [shared specifications](https://azure.github.io/Azure-Verified-Modules/specs/shared/) (including [Interfaces](https://azure.github.io/Azure-Verified-Modules/specs/shared/interfaces/)) and [Terraform-specific](https://azure.github.io/Azure-Verified-Modules/specs/terraform/) specifications as as these need to be considered during pull request reviews for the modules you own.
2. Familiarise yourself with the AVM Resource Module Naming in the [module index csv's](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes).
3. Example: `terraform-<provider>-avm-res-<rp>-<ARM resource type>`
4. Create GitHub teams:
5. `@Azure/avm-res-<RP>-<modulename>-module-owners-tf`
6. `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf`
7. Create the module repostory using [terraform-azuremrm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template) in Azure organization with the following [details](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review). You will then have to complete configuration of your repo and start an internal business review.
   See [this link (internal only)](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review?anchor=conduct-initial-repo-configuration-and-trigger-business-review).
8. Add the teams with following permissions to the repository:
9. Admin: `@Azure/avm-core-team`
10. Admin: `@Azure/terraform-azure` = Terraform PG
11. Write: `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf` = AVM Resource Module Contributors
12. Admin: @Azure/avm-res-<RP>-<modulename>-module-owners-tf = AVM Resource Module Owners
13. Set Labels: As per [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) the repositories created by module owners **MUST** have and use the pre-defined GitHub labels. To apply these labels to the repository review the PowerShell script `Set-AvmGitHubLabels.ps1` that is provided in [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels).
14. Publish the module:
15. Ensure your module is ready for publishing:
16. All tests are passing.
17. All examples are passing.
18. All documentation is generated.
19. A pull request approval from a member of the [`@Azure/avm-core-team-technical`](https://github.com/orgs/Azure/teams/avm-core-team-technical/members).
20. There is a release tag in the repo
21. If you are using Just In Time (JIT) admin access to your repo, visit the internal repos page to elevate your access.
22. Sign in to the [HashiCorp Registry](https://registry.terraform.io/) using GitHub
23. Publish a module by selecting the `Publish` button in the top right corner, then `Module`
24. Select the repository and accept the terms.

{{< hint type=important >}}

When the AVM Modules are published to the HashiCorp Registry, they **MUST** follow the below requirements:

- Resource Module: `terraform-<provider>-avm-res-<rp>-<ARM resource type>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `terraform-<provider>-avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

{{< /hint >}}

<br>

---

<br>
