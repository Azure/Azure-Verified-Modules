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
A(1. Fork the module source repository)
  click A "/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#1-fork-the-module-source-repository"
B(2. Setup your Azure test environment)
  click B "/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#2-prepare-your-azure-test-environment"
C(3. Implement your contribution)
  click C "/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#3-implement-your-contribution"
D{4. Pre-commit Checks <br> succesful?}
  click D "/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#4-run-pre-commit-checks"
E(5. Create a pull request to the upstream repository)
  click E "/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/#5-create-a-pull-request-to-the-upstream-repository"
A --> B
B --> C
C --> D
D -->|yes|E
D -->|no|C
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

<img src="/Azure-Verified-Modules/img/contribution/forkUpstream.png" alt="Upstream to fork and source repository." width=50%>

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

Each time in the following sections we refer to 'your xyz', it is an indicator that you have to change something in your own environment.

{{< /hint >}}

## Prepare your developer environment

### 1. Fork the module source repository

{{< hint type=important >}}

Each Terraform AVM module will have its own GitHub repository in the [`Azure`](https://github.com/Azure) GitHub Organization as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

This repository will be created by the Module owners and the AVM Core team collaboratively, including the configuration of permissions as per [SNFR9](/Azure-Verified-Modules/specs/shared/#id-snfr9---category-contributionsupport---avm--pg-teams-github-repo-permissions)

{{< /hint >}}

Module contributors are expected to fork the corresponding repository and work on a branch from within their fork, before then creating a Pull Request (PR) back into the source repository's `main` branch.

To do so, simply navigate to your desired repository, select the `'Fork'` button to the top right of the UI, select where the fork should be created (i.e., the owning organization) and finally click 'Create fork'.

{{< hint type=note >}}

If the module repository you want to contribute to is not yet available, please get in touch with the respective module owner which can be tracked in the [Terraform Resource Modules index](/Azure-Verified-Modules/indexes/terraform/tf-resource-modules/) see `PrimaryModuleOwnerGHHandle` column.

_**Optional:**_ The usage of local source branches

For consistent contributors but also Azure-org members in general it is possible to get invited as collaborator of the module repository which enables you to work on branches instead of forks. To get invited get in touch with the module owner since it's the module owner's decision who gets invited as collaborator.

{{< /hint >}}

<br>

---

<br>

### 2. Prepare your Azure test environment

AVM performs end-to-end (e2e) test dpeloyments of all modules in Azure for validation. We recommend you to perform a local e2e test deployment of your module before you create a PR to the upstream repository. Especially because the e2e test deployment will be triggered automatically once you create a PR to the upstream repository.

1. Have/create an Azure Active Directory Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You might find the following links useful:

    - [Create a service principal (Azure CLI)](https://learn.microsoft.com/en-us/cli/azure/azure-cli-sp-tutorial-1) - _**Recommended**_
    - [Create a service principal (Azure Portal)](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)
    - [Create a service principal (PowerShell)](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-authenticate-service-principal-powershell)
    - [Find Service Principal object ID](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/assign-roles-azure-service-principals#find-your-spn-and-tenant-id)
    - [Find managed Identity Service Principal](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-view-managed-identity-service-principal-portal)
    - Note down the following pieces of information
    - Application (Client) ID
    - Service Principal Secret (password)
    - **Optional:** Tenant ID
    - **Optional:** Subscription ID

    ```bash
    # Linux/MacOs
    export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv) # or set <subscription_id>
    export ARM_TENANT_ID=$(az account show --query tenantId --output tsv) # or set <tenant_id>
    export ARM_CLIENT_ID=<client_id>
    export ARM_CLIENT_SECRET=<service_principal_password>

    # Windows/Powershell
    $env:ARM_SUBSCRIPTION_ID = $(az account show --query id --output tsv) # or set <subscription_id>
    $env:ARM_TENANT_ID = $(az account show --query tenantId --output tsv) # or set <tenant_id>
    $env:ARM_CLIENT_ID = "<client_id>"
    $env:ARM_CLIENT_SECRET = "<service_principal_password>"
    ```

2. Change to the root of your module repository and run `./avm docscheck` (Linux/MacOs) / `avm.bat docscheck` (Windows) to verify the container image is working as expected or needs to be pulled first. You will need this later.

    <img src="/Azure-Verified-Modules/img/contribution/pullImage.png" alt="Pull latest azterraform container image." width=100%>

<br>

---

<br>

### 3. Implement your contribution

To implement your contribution, we kindly ask you to first review the [shared](/Azure-Verified-Modules/specs/shared/) & [Terraform-specific](/Azure-Verified-Modules/specs/terraform/) specifications and [composition guidelines](/Azure-Verified-Modules/contributing/bicep/terraform/) in particular to make sure your contribution complies with the repository's design and principles.

{{< hint type=tip >}}
To get a head start on developing your module, consider using the tooling recommended per spec [TFNFR37](https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tfnfr37---category-code-style---tool-usage-by-module-owner). For example you can use the [newres](https://github.com/lonegunmanb/newres) tool to help with  creating `variables.tf` and `main.tf` if you're developing a module using Azurerm provider.
{{< /hint >}}

<br>

---

<br>

### 4. Run Pre-commit Checks

{{< hint type=important >}}

Make sure you have **Docker** installed and running on your machine.

{{< /hint >}}

{{< hint type=note >}}

To simplify and help with the execution of commands like `pre-commit`, `pr-check`, `docscheck`, `fmt`, `test-example`, etc. there is now a simplified [avm](https://github.com/Azure/terraform-azurerm-avm-template/blob/main/avm) script available distributed to all repositories via [`terraform-azurerm-avm-template`](https://github.com/Azure/terraform-azurerm-avm-template) which combines all scripts from the [avm_scripts](https://github.com/Azure/tfmod-scaffold/tree/main/avm_scripts) folder in the [tfmod-scaffold](https://github.com/Azure/tfmod-scaffold/) repository using [avmmakefile](https://github.com/Azure/tfmod-scaffold/blob/main/avmmakefile).

The avm script also makes sure to pull the latest `mcr.microsoft.com/azterraform:latest` container image before executing any command.

{{< /hint >}}

#### 4.1. Run pre-commit and pr-check

The following commands will run all pre-commit checks and the pr-check.

```bash
# Running all pre-commit checks
# `pre-commit` runs depsensure fmt fumpt autofix docs
# `pr-check` runs fmtcheck tfvalidatecheck lint unit-test

## Linux/MacOs
./avm pre-commit
./avm pr-check

## Windows
avm.bat pre-commit
avm.bat pr-check
```

#### 4.2 Run e2e tests

Currently you have two options to run e2e tests:

{{< hint type=note >}}

With the help of the [avm](https://github.com/Azure/terraform-azurerm-avm-template/blob/main/avm) script and the commands `./avm test-example` (Linux/MacOs) / `avm.bat test-example` (Windows) you will be able to run it in a more simplified way. Currently the `test-example` command is not completely ready yet and will be released soon. Therefore please use the below docker command for now.

{{< /hint >}}

1. Run e2e tests with the help of the azterraform docker container image.

    ```bash
    # Linux/MacOs

    docker run --rm -v $(pwd):/src -w /src -v $HOME/.azure:/root/.azure -e TF_IN_AUTOMATION -e AVM_MOD_PATH=/src -e AVM_EXAMPLE=<example_folder> -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make test-example

    # Powershell

    docker run --rm -v ${pwd}:/src -w /src -v $HOME/.azure:/root/.azure -e TF_IN_AUTOMATION -e AVM_MOD_PATH=/src -e AVM_EXAMPLE=<example_folder> -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make test-example
    ```

    Make sure to replace `<client_id>` and `<service_principal_password>` with the values of your service principal as well as `<example_folder>` (e.g. `default`) with the name of the example folder you want to run e2e tests for.

2. Run e2e tests with the help of terraform init/plan/apply.

    Simply run `terraform init` and `terraform apply` in the `example` folder you want to run e2e tests for. Make sure to set the environment variables `ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`, `ARM_CLIENT_ID` and `ARM_CLIENT_SECRET` before you run `terraform init` and `terraform apply` or make sure you have a valid Azure CLI session and are logged in with `az login`.

<br>

---

<br>

### 5. Create a pull request to the upstream repository

Once you are satisfied with your contribution and validated it, submit a pull request to the upstream repository and work with the module owner to get the module reviewed by the AVM Core team, by following the initial module review process for Terraform Modules, described [here](/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/owner-contribution-flow/#6-review-the-module). This is a prerequisite for publishing the module. Once the review process is complete and your PR is approved, merge it into the upstream repository and the Module owner will [publish](/Azure-Verified-Modules/contributing/terraform/terraform-contribution-flow/owner-contribution-flow/#7-publish-the-module) the module to the HashiCorp Terraform Registry.

<br>

---

<br>

### Common mistakes to avoid and recommendations to follow

- If you contribute to a new module then search and update `TODOs` (which are coming with the [terraform-azurerm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template)) within the code and remove the `TODO` comments once complete
- `terraform.lock.hcl` shouldn't be in the repository as per the `.gitignore` file
- Update the `support.md` file
- `\_header.md` needs to be updated
- `support.md` needs to be updated
- `locals.telemetry.tf` needs to be updated
- Exclude `terraform.tfvars` file from the repository
