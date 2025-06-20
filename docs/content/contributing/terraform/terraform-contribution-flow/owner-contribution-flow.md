---
title: Terraform Owner Contribution Flow
linktitle: Owner Contribution Flow
description: Terraform Owner Contribution Flow for the Azure Verified Modules (AVM) program
---

This section describes the contribution flow for module owners who are responsible for creating and maintaining Terraform Module repositories.

{{% notice style="important" %}}

This contribution flow is for **Module owners** only.

As a Terraform Module Owner you need to be aware of the [AVM contribution process overview]({{% siteparam base %}}/contributing/process/) & [Terraform specifications]({{% siteparam base %}}/specs/tf/) (including [Interfaces]({{% siteparam base %}}/specs/tf/interfaces/)) as as these need to be considered during pull request reviews for the modules you own.

{{% /notice %}}

{{% notice style="info" %}}

Make sure module authors/contributors tested their module in their environment before raising a PR. The PR uses e2e checks with 1ES agents in the 1ES subscriptions. At the moment their is no read access to the 1ES subscription. Also if more than two subscriptions are required for testing, that's currently not supported.

{{% /notice %}}

### 1. Owner Activities and Responsibilities

<!-- TODO: Add TF Issue Triage once done -->
Familiarise yourself with the responsibilities as **Module Owner** outlined in [Team Definitions & RACI]({{% siteparam base %}}/specs/shared/team-definitions/#module-owners) and in the [TF Issue Triage]({{% siteparam base %}}/help-support/issue-triage/).

1. Watch Pull Request (PR) and issue (questions/feedback) activity for your module(s) in your repository and ensure that PRs are reviewed and merged in a timely manner as outlined in [SNFR11]({{% siteparam base %}}/spec/SNFR11).

{{% notice style="info" %}}

Make sure module authors/contributors tested their module in their environment before raising a PR. Also because once a PR is raised a e2e GitHib workflow pipeline is required to be run successfully before the PR can be merged. This is to ensure that the module is working as expected and is compliant with the AVM specifications.

{{% /notice %}}

### 2. GitHub repository creation and configuration

Once your module has been approved and you are ready to start development, you need to request that a new repository be created for your module.

You do that by adding a comment to the [issue](https://github.com/Azure/Azure-Verified-Modules/issues) with the `#RFRC` tag. The &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#136A41;color:white;">Status: Ready For Repository Creation 📝</mark>&nbsp; label will then be applied. This will trigger the creation of the repository and the configuration of the repository with the required settings.

{{% notice style="info" %}}
If you need your repository to be created urgently, please message the AVM Core team in the AVM Teams channel.
{{% /notice %}}

Once your module is ready for development, the &nbsp;<mark style="background-image:none;white-space: nowrap;background-color:#27AB03;color:white;">Status: Repository Created 📄</mark>&nbsp; label will be added to the issue and you'll be notified it is ready.

### 3. Module Development Activities

You can now start developing your module, following standard guidance for Terraform module development.

Some useful things to know:

#### Pull Request

You can raise a pull request anytime, don't wait until the end of the development cycle. Raise the PR after you first push your branch.

You can then use the PR to run end to end tests, check linting, etc.

Once readdy for review, you can request a review per step 4.

#### Grept

[Grept](https://github.com/Azure/grept) is a linting tool for repositories, ensures predefined standards, maintains codebase consistency, and quality.
It's using the grept configuration files from the [Azure-Verified-Modules-Grept](https://github.com/Azure/Azure-Verified-Modules-Grept) repository.

You can see [here](https://github.com/Azure/Azure-Verified-Modules-Grept/blob/main/terraform/synced_files.grept.hcl) which files are synced from the [`terraform-azurerm-avm-template`](https://github.com/Azure/terraform-azurerm-avm-template) repository.

Set environment variables and run Grept:

```bash
export GITHUB_REPOSITORY_OWNER=Azure
export GITHUB_REPOSITORY=Azure/terraform-azurerm-avm-res-<RP>-<modulename>"

./avm grept-apply
```

```pwsh
$env:GITHUB_REPOSITORY_OWNER="Azure"
$env:GITHUB_REPOSITORY="Azure/terraform-azurerm-avm-res-<RP>-<modulename>"

./avm grept-apply
```

#### Custom Variables and Secrets for end to end tests

The respoitory has an environment called `test`, it has have approvals and secrets applied to it ready to run end to end tests.

- In the unusual cicumstance that you need to use your own tenant and subscription for end to end tests, you can override the secrets by setting `ARM_TENANT_ID_OVERRIDE`, `ARM_SUBSCRIPTION_ID_OVERRIDE`, and `ARM_CLIENT_ID_OVERRIDE` secrets.
- If you need to supply additional secrets or variables for your end to end tests, you can add them to the `test` environment. They must be prefixed with `TF_VAR_`, otherwise they will be ignored.

### 4. Review the module

Once the development of the module has been completed, get the module reviewed from the AVM Core team by following the AVM Review of Terraform Modules process [here]({{% siteparam base %}}/contributing/terraform/review/) which is a pre-requisite for the next step.

### 5. Publish the module

Once a module has been reviewed and the PR is merged to `main`. Follow the below steps to publish the module to the HashiCorp Registry.

Ensure your module is ready for publishing:

1. Create a release with a new tag (e.g. `0.1.0`) via [Github UI](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository).
    - Go to the releases tab and click on `Draft a new release`.
    - Ensure that the `Target` is set to the `main` branch.
    - Select `Choose a tag` and type in a new tag, such as `0.1.0` Make sure to create the tag from the `main` branch.
    - Generate the release notes using the `Generate release notes` button.
    - If this is a community contribution be sure to update the 'Release Notes` to provide appropriate credit to the contributors.

    ![DeploymentProtectionRules]({{% siteparam base %}}/images/contribution/gitTag.png "GitHub Release")

2. Elevate your respository access using the [Open Source Management Portal](https://aka.ms/opensource/portal).
3. Sign in to the [HashiCorp Registry](https://registry.terraform.io/) using GitHub.
4. Publish a module by selecting the `Publish` button in the top right corner, then `Module`
5. Select the repository and accept the terms.

{{% notice style="info" %}}

Once a module gets updated and becomes a new version/release it will be automatically published with the latest published release version to the HashiCorp Registry.

{{% /notice %}}

{{% notice style="important" %}}

When an AVM Module is published to the HashiCorp Registry, it **MUST** follow the below requirements:

- Resource Module: `terraform-<provider>-avm-res-<rp>-<ARM resource type>` as per [RMNFR1]({{% siteparam base %}}/spec/RMNFR1)
- Pattern Module: `terraform-<provider>-avm-ptn-<patternmodulename>` as per [PMNFR1]({{% siteparam base %}}/spec/PMNFR1)

{{% /notice %}}
