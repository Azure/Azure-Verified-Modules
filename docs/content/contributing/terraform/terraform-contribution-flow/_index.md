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
A(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#1-fork-the-module-source-repository'>1. Fork the module source repository </a>)
B(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#2-setup-your-github-repository'>2. Setup your GitHub repository</a>)
C(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#3-setup-your-azure-test-environment'>3. Setup your Azure test environment </a>)
D(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#4-configure-your-ci-environment'>4. Configure CI environment </a><br> For module tests)
E(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#5-implement-your-contribution'>5. Implement your contribution </a><br> For module tests)
F{<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#6-run-pre-commit-checks'>6. Pre-commit Checks <br> succesful?</a>}
G(<a href='/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#7-create-a-pull-request-to-the-upstream-repository'>7. Create a pull request to the upstream repository</a>)
A --> B
B --> C
C --> D
D --> E
F -->|yes|G
F -->|no|E
{{< /mermaid >}}

<br>

---

<br>

## GitFlow for contributors

The GitFlow process outlined here depicts and suggests a way of working with Git and GitHub. It serves to synchronize the forked repository with the original upstream repository. It is not a strict requirement to follow this process, but it is highly recommended to do so.

{{< mermaid class="text-center" >}}
%%{init: { 'logLevel': 'debug', 'gitGraph': {'rotateCommitLabel': false}} }%%
gitGraph LR:
commit id:"fork"
branch fork/main
checkout fork/main
commit id:"checkout feature" type: HIGHLIGHT
branch feature
checkout feature
commit id:"checkout fix"
branch fix
checkout main
merge feature id: "Pull Request 'Feature'" type: HIGHLIGHT
checkout fix
commit id:"Patch 1"
commit id:"Patch 2"
checkout main
merge fix id: "Pull Request 'Fix'" type: HIGHLIGHT
{{< /mermaid >}}

{{< hint type=tip >}}

When implementing the GitFlow process as described, it is advisable to configure the local clone of your forked repository with an additional remote for the upstream repository. This will allow you to easily synchronize your locally forked repository with the upstream repository. **_Remember_**, there is a difference between the forked repository on GitHub and the clone of the forked repository on your local machine.

<img src="../../../img/contribution/forkUpstream.png" alt="Upstream to fork and source repository." width=50%>

{{< /hint >}}

<br>

---

<br>

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

## Prepare your developer environment

### 1. Fork the module source repository

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

### 2. Setup your GitHub repository

1. Set up a GitHub repository environment called `test`.
2. Configure an environment protection rule to ensure that approval is required before deploying to the `test` environment.
<!-- TODO: secrets can be removed since the latest azteraform docker image with having ./avm implemented -->
3. Create the following environment secrets on the `test` environment

- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

{{< hint type=important >}}

There is a move from the `test` environment to GitHub self-hosted runners (1ES Pool) which soon makes the above secrets obsolete. This is currently in progress.

{{< /hint >}}

<br>

---

<br>

### 3. Setup your Azure test environment

AVM tests the deployments in an Azure subscription. To do so, it requires a service principal with access to it.

In this first step, make sure you

1. Create a user-assigned managed identity in your test subscription.
2. Create a role assignment for the managed identity on your test subscription, use `Contributor` role (your module might require higher privileges).
3. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.

<br>

---

<br>

### 4. Configure your CI environment

{{< hint type=important >}}

Make sure you have **Docker** installed on your machine.

{{< /hint >}}

1. Download `azterraform` Docker image.
2. Run `azterraform` Docker image.
3. ...

<br>

---

<br>

### 5. Implement your contribution

Code!

<br>

---

<br>

### 6. Run Pre-commit Checks

- [6.1 Run grept](#52-run-e2e-tests)
- [6.2 Check/Generate module documentation](#52-checkgenerate-module-documentation)
- [6.3 Format Terraform code](#51-format-terraform-code)
- [6.4 Run e2e tests](#53-run-e2e-tests)

{{< hint type=tip >}}

To simplify and help with the execution of commands like `docscheck`, `terraform-docs`, `terraform-fmt`, etc. there is now a simplified [avm](https://github.com/Azure/terraform-azurerm-avm-template/blob/main/avm) script available in the [`terraform-azurerm-avm-template`](https://github.com/Azure/terraform-azurerm-avm-template) repository which combines all scripts from the avm_scripts folder in the tfmod-scaffold https://github.com/Azure/tfmod-scaffold/tree/main/avm_scripts respositroy. ONce you run grept it will also download/synchronize the avm script for you with your local repository.

{{< /hint >}}

https://github.com/Azure/tfmod-scaffold/blob/main/avmmakefile

#### 6.1 Run grept

[Grept](https://github.com/Azure/grept) is a linting tool for repositories, ensures predefined standards, maintains codebase consistency, and quality.
It's using the grept configuration files from the [Azure-Verified-Modules-Grept](https://github.com/Azure/Azure-Verified-Modules-Grept) repository.

You can see [here](https://github.com/Azure/Azure-Verified-Modules-Grept/blob/main/terraform/synced_files.grept.hcl) which files are synced from the [`terraform-azurerm-avm-template`](https://github.com/Azure/terraform-azurerm-avm-template) repository.

1. Set environment variables

```
# Linux/MacOS
export GITHUB_REPOSITORY_OWNER=Azure
export GITHUB_REPOSITORY=Azure/terraform-azurerm-avm-res-<RP>-<modulename>"

# Windows

$env:GITHUB_REPOSITORY_OWNER="Azure"
$env:GITHUB_REPOSITORY="Azure/terraform-azurerm-avm-res-<RP>-<modulename>"
```

1. Run grept

```bash
grept apply -a git::https://github.com/Azure/Azure-Verified-Modules-Grept.git//terraform
```

#### 6.2. Check/Generate module documentation

```bash
./avm docscheck # comparing generated README.md with the one in the repo
./avm docs # generating module documentation like README.md including examples
```

#### 6.3 Format Terraform code

```bash
./avm fmt
```

#### 6.4 Run e2e tests

<br>

---

<br>

### 7. Create a pull request to the upstream repository.

Once you are satisfied with your contribution and validated it, open a PR from your forked repository to the original Terraform Module repository. Make sure you:

1. Include/Add [`@Azure/avm-core-team-technical`](https://github.com/orgs/Azure/teams/avm-core-team-technical/members) as a reviewer.
2. Make sure all Pull Requst Checks (e2e tests with all examples, linting and version-check) are passing.

<br>

---

<br>

### Common mistakes to avoid and recommendations to follow

<!--
TODO:
- might be worth adding `terraform.tfvars` to `.gitignore` ? -->

- If you contribute to a new module then search and update `TODOs` (which are coming with the [terraform-azurerm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template)) within the code and remove the `TODO` comments once complete
- `terraform.lock.hcl` shouldn't be in the repository as per the `.gitignore` file
- Update the `support.md` file
- Consider following specs [TFNFR31](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tfnfr31---category-code-style---localstf-must-contain-only-one-locals-block) for the `local.tf` file
- Consider updating version to `0.1.0` as the first version that would be published into the terraform registry per spec [SNFR17](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning)
- Set `prevent_deletion_if_contains_resources` to `false` in provider block in example code per spec [TFNFR36](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tfnfr36---category-code-style---example-code-must-set-prevent_deletion_if_contains_resources-to-false-in-provider-block)
- The `Contributor` and `Owner` teams are not added to the repository per spec [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only).
- `\_header.md` needs to be updated
- `readme.md` needs to be generated as per spec [SNFR15](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr15---category-documentation---automatic-documentation-generation) & [TFNFR2](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tfnfr2---category-documentation---module-documentation-generation)
- `support.md` needs to be updated
- `locals.telemetry.tf` needs to be updated
- Define outputs like Resource Name, ID and Object in `outputs.tf` per specs [RMFR7](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmfr7---category-outputs---minimum-required-outputs) & [TFFR2](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs)
- Consider setting a constraint on maximum major version of Provider per spec [TFNFR26](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tfnfr26---category-code-style---provider-version-constraint-must-have-a-constraint-on-maximum-major-version) in `terraform.tf` flle
- Exclude `terraform.tfvars` file from the repository
- Make sure to have all interfaces defined as per spec [RMFR5](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-rmfr5---category-composition---avm-consistent-feature--extension-resources-value-add-interfacesschemas)
- Declaration of provider in module should be as per spec [TFNFR27](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tfnfr27---category-code-style---declaration-of-a-provider-in-the-module) in `main.tf`
- `CODEOWNERS` file needs to be updated as per spec [SNFR9](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions) & [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#codeowners-file)

<br>

---

<br>
```
