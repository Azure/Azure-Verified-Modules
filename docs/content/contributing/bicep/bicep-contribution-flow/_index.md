---
title: Bicep Contribution Flow
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

## High-level contribution flow

{{< mermaid class="text-center" >}}
flowchart TD
A("1 - Fork the module source repository")
  click A "/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#1-fork-the-module-source-repository"
B(2 - Configure a deployment identity in Azure)
  click B "/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#2-configure-a-deployment-identity-in-azure"
C(3 - Configure CI environment <br> For module tests)
  click C "/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#3-configure-your-ci-environment"
D(4 - Implementing your contribution<br> Refer to Gitflow Diagram below)
  click D "/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution"
E(5 - Workflow test <br> completed <br> successfully?)
  click E "/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#5-createupdate-and-run-tests"
F(6 - Create a pull request to the upstream repository)
  click F "/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#6-create-a-pull-request-to-the-public-bicep-registry"
A --> B
B --> C
C --> D
D --> E
E -->|yes|F
E -->|no|D
{{< /mermaid >}}

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

## PowerShell Helper Script To Setup Fork & CI Test Environment

{{< hint type=Caution title="Only available for Service Principal + Secret authentication method [Deprecated]">}}

The PowerShell Helper Script currently only supports the Service Principal + Secret authentication method, which is deprecated.
It is recommended to start adopting OpenID Connect (OIDC) authentication instead.

{{< /hint >}}

To simplify the setup of the fork, clone and configuration of the required secrets, SPN and RBAC assignments in your Azure environment for the CI framework to function correctly in your fork, we have created a PowerShell script that you can use to do steps [1](#1-fork-the-module-source-repository), [2](#2-configure-a-deployment-identity-in-azure) & [3](#3-configure-your-ci-environment) below.

{{< hint type=important >}}

You will still need to complete [step 3.3](#33-set-readwrite-workflow-permissions) manually at this time.

{{< /hint >}}

The script performs the following steps:

1. Forks the `Azure/bicep-registry-modules` to your GitHub Account.
2. Clones the repo locally to your machine, based on the location you specify in the parameter: `-GitHubRepositoryPathForCloneOfForkedRepository`.
3. Prompts you and takes you directly to the place where you can enable GitHub Actions Workflows on your forked repo.
4. Disables all AVM module workflows, as per [Enable or Disable Workflows](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/).
5. Creates an Azure Service Principal (SPN) and grants it the RBAC roles of `User Access Administrator` & `Contributor` at Management Group level, if specified in the `-GitHubSecret_ARM_MGMTGROUP_ID` parameter, and at Azure Subscription level if you provide it via the `-GitHubSecret_ARM_SUBSCRIPTION_ID` parameter.
6. Creates the required GitHub Actions Secrets in your forked repo as per [step 3](#3-configure-your-ci-environment), based on the input provided in parameters and the values from resources the script creates, such as the SPN.

### Pre-requisites

1. You must have the [Azure PowerShell Modules](https://learn.microsoft.com/powershell/azure/install-azure-powershell) installed and you need to be logged with the context set to the desired Tenant. You must have permissions to create an SPN and grant RBAC over the specified Subscription and Management Group, if provided.
2. You must have the [GitHub CLI](https://github.com/cli/cli#installation) installed and need to be authenticated with the GitHub user account you wish to use to fork, clone and work with on AVM.

{{< expand "New-AVMBicepBRMForkSetup.ps1 - PowerShell Helper Script" "expand/collapse" >}}

The `New-AVMBicepBRMForkSetup.ps1` can be downloaded from <a href="/Azure-Verified-Modules/scripts/New-AVMBicepBRMForkSetup.ps1" download>here</a>.

Once downloaded, you can run the script by running the below - **Please change all the parameter values in the below script usage example to your own values (see the parameter documentation in the script itself)!**:
```powershell
.\<PATH-TO-SCRIPT-DOWNLOAD-LOCATION>\New-AVMBicepBRMForkSetup.ps1 -GitHubRepositoryPathForCloneOfForkedRepository "<pathToCreateForkedRepoIn>" -GitHubSecret_ARM_MGMTGROUP_ID "<managementGroupId>" -GitHubSecret_ARM_SUBSCRIPTION_ID "<subscriptionId>" -GitHubSecret_ARM_TENANT_ID "<tenantId>" -GitHubSecret_TOKEN_NAMEPREFIX "<unique3to5AlphanumericStringForAVMDeploymentNames>"
```

For more examples, see the below script's parameters section.

{{< include file="/static/scripts/New-AVMBicepBRMForkSetup.ps1" language="pwsh" options="linenos=false" >}}

{{< /expand >}}

## 1. Fork the module source repository

{{< hint type=tip >}}

Checkout the [PowerShell Helper Script](#powershell-helper-script-to-setup-fork--ci-test-environment) that can do this step automatically for you! 👍

{{< /hint >}}

{{< hint type=note >}}

Each time in the following sections we refer to 'your xyz', it is an indicator that you have to change something in your own environment.

{{< /hint >}}

Bicep AVM Modules (Resource, Pattern and Utility modules) are located in the `/avm` directory of the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository, as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

Module owners are expected to fork the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and work on a branch from within their fork, before creating a Pull Request (PR) back into the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository's upstream `main` branch.

To do so, simply navigate to the [Public Bicep Registry](https://github.com/Azure/bicep-registry-modules) repository, select the `'Fork'` button to the top right of the UI, select where the fork should be created (i.e., the owning organization) and finally click 'Create fork'.

### 1.1 Create a GitHub environment

Create the `avm-validation` environment in your fork.

{{< expand "➕ How to: Create an environment in GitHub" "expand/collapse" >}}

1. Navigate to the repository's `Settings`.

2. In the list of settings, expand `Environments`. You can create a new environment by selecting `New environment` on the top right.

3. In the opening view, provide `avm-validation` for the environment `Name`. Click on the `Configure environment` button.

<img src="../../../img/bicep-ci/forkSettingsEnvironmentAdd.png" alt="Add environment" width=100%>

Please ref the following link for additional details: [Creating an environment](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment#creating-an-environment)

{{< /expand >}}

<br>


## 2. Configure a deployment identity in Azure

AVM tests its modules via deployments in an Azure subscription. To do so, it requires a deployment identity with access to it.

{{< hint type=warning title="Deprecating the Service Principal + Secret authentication method">}}

Support for the 'Service Principal + Secret' authentication method has been deprecated and will be decommissioned in the future.

It is highly recommended to start leveraging Option 1 below to adopt OpenID Connect (OIDC) authentication and align with security best practices.

{{< /hint >}}

{{< expand "➕ Option 1 [Recommended]: OIDC - Configure a federated identity credential" "expand/collapse" >}}

1. Create a new or leverage an existing user-assigned managed identity with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You might find the following links useful:
    - [Create a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities#create-a-user-assigned-managed-identity)
    - [Assign an appropriate role to your user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities#manage-access-to-user-assigned-managed-identities)

    <img src="../../../img/bicep-ci/msiOIDCRole.png" alt="OIDC identity roles" width=100%>

{{< hint type=note title="Additional roles">}}

Some Azure resources may require additional roles to be assigned to the deployment identity. An example is the `avm/res/aad/domain-service` module, which requires the deployment identity to have the Domain Services Contributor Azure role to create the required Domain Services resources.

In those cases, for the first PR adding such modules to the public registry, we recommend the author to reach out to AVM maintainers or, alternatively, to [create a CI environment GitHub issue](https://github.com/Azure/bicep-registry-modules/issues/new?template=avm_ci_environment_issue.yml) in BRM, specifying the additional prerequisites. This ensures that the required additional roles get assigned in the upstream CI environment before the corresponding PR gets merged.

{{< /hint >}}

2. Configure a federated identity credential on a user-assigned managed identity to trust tokens issued by GitHub Actions to your GitHub repository.
    - In the Microsoft Entra admin center, navigate to the user-assigned managed identity you created. Under `Settings` in the left nav bar, select `Federated credentials` and then `Add Credential`.
      <img src="../../../img/bicep-ci/msiOIDCAddFederatedIdentity_01.png" alt="OIDC federated credentials" width=60%>
    - In the Federated credential scenario dropdown box, select `GitHub Actions deploying Azure resources`
      <img src="../../../img/bicep-ci/msiOIDCAddFederatedIdentity_02.png" alt="OIDC scenario" width=80%>
    - For the `Organization`, specify your GitHub organization name, for the `Repository` the value `bicep-registry-modules`.
    - For the `Entity` type, select `Environment` and specify the value `avm-validation`.
    - Add a Name for the federated credential, for example, `avm-gh-env-validation`.
    - The `Issuer`, `Audiences`, and `Subject identifier` fields autopopulate based on the values you entered.
    - Select `Add` to configure the federated credential.
      <img src="../../../img/bicep-ci/msiOIDCAddFederatedIdentity_03.png" alt="OIDC Add" width=80%>
    - You might find the following links useful:
      - [Configure a federated identity credential on a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust-user-assigned-managed-identity)
3. Note down the following pieces of information
    - Client ID
    - Tenant ID
    - Subscription ID
    - Parent Management Group ID

    <img src="../../../img/bicep-ci/msiOIDCInfo.png" alt="OIDC Add" width=70%>

Additional references:
- [Configure a federated identity credential](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect#prerequisites)
- [Azure login GitHub action - Login with OIDC](https://github.com/Azure/login?tab=readme-ov-file#login-with-openid-connect-oidc-recommended)

{{< /expand >}}

{{< expand "➕ Option 2 [Deprecated]: Configure Service Principal + Secret" "expand/collapse" >}}

1. Create a new or leverage an existing Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You might find the following links useful:
    - [Create a service principal (Azure Portal)](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)
    - [Create a service principal (PowerShell)](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-authenticate-service-principal-powershell)
    - [Find Service Principal object ID](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/assign-roles-azure-service-principals#find-your-spn-and-tenant-id)
    - [Find managed Identity Service Principal](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-view-managed-identity-service-principal-portal)
2. Note down the following pieces of information
    - Application (Client) ID
    - Service Principal Object ID (**not** the object ID of the application)
    - Service Principal Secret (password)
    - Tenant ID
    - Subscription ID
    - Parent Management Group ID

{{< /expand >}}

<br>


## 3. Configure your CI environment

{{< hint type=tip >}}

Checkout the [PowerShell Helper Script](#powershell-helper-script-to-setup-fork--ci-test-environment) that can do this step automatically for you! 👍

{{< /hint >}}

To configure the forked CI environment you have to perform several steps:

- [3.1 Set up secrets](#31-set-up-secrets)
- [3.2 Enable actions](#32-enable-actions)
- [3.3 Set Read/Write Workflow permissions](#33-set-readwrite-workflow-permissions)

### 3.1. Set up secrets

#### 3.1.1 Shared repository secrets

To use the _Continuous Integration_ environment's workflows you should set up the following repository secrets:

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `11111111-1111-1111-1111-111111111111` | The group ID of the management group to test-deploy modules in. Is needed for resources that are deployed to the management group scope. |
| `ARM_SUBSCRIPTION_ID` | `22222222-2222-2222-2222-222222222222` | The ID of the subscription to test-deploy modules in. Is needed for resources that are deployed to the subscription scope. Note: This repository secret will be deprecated in favor of the `VALIDATE_SUBSCRIPTION_ID` environment secret required by the OIDC authentication. |
| `ARM_TENANT_ID` | `33333333-3333-3333-3333-333333333333` | The tenant ID of the Azure Active Directory tenant to test-deploy modules in. Is needed for resources that are deployed to the tenant scope. Note: This repository secret will be deprecated in favor of the `VALIDATE_TENANT_ID` environment secret required by the OIDC authentication. |
| `TOKEN_NAMEPREFIX` | `cntso` | Required. A short (3-5 character length), unique string that should be included in any deployment to Azure. Usually, AVM Bicep test cases require this value to ensure no two contributors deploy resources with the same name - which is especially important for resources that require a globally unique name (e.g., Key Vault). These characters will be used as part of each resource's name during deployment. For more information, see the `[Special case: TOKEN_NAMEPREFIX]` note below. |

{{< hint type=note title="Special case: TOKEN_NAMEPREFIX">}}

To lower the barrier to entry and allow users to easily define their own naming conventions, we introduced a default 'name prefix' for all deployed resources.

This prefix is **only** used by the CI environment you validate your modules in, and doesn't affect the naming of any resources you deploy as part of any solutions (applications/workloads) based on the modules.

Each workflow in AVM deploying resources uses a logic that automatically replaces "tokens" (i.e., placeholders) in any module test file. These tokens are, for example, included in the resources names (e.g. `'name: kvlt-${namePrefix}'`). Tokens are stored as repository secrets to facilitate maintenance.

{{< /hint >}}

<p>

{{< expand "➕ How to: Add a repository secret to GitHub" "expand/collapse" >}}

1. Navigate to the repository's `Settings`.

    <img src="../../../img/bicep-ci/forkSettings.png" alt="Navigate to settings" width=100%>

2. In the list of settings, expand `Secrets` and select `Actions`. You can create a new repository secret by selecting `New repository secret` on the top right.

    <img src="../../../img/bicep-ci/forkSettingsSecrets.png" alt="Navigate to secrets" width=100%>

3. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.

    <img src="../../../img/bicep-ci/forkSettingsSecretAdd.png" alt="Add secret" width=100%>

{{< /expand >}}


#### 3.1.2 Authentication secrets

In addition to shared repository secrets detailed above, additional GitHub secrets are required to allow the deploying identity to authenticate to Azure.

Expand and follow the option corresponding to the deployment identity setup chosen at [Step 2](#2-configure-a-deployment-identity-in-azure) and use the information you gathered during that step.


{{< expand "➕ Option 1 [Recommended]: Authenticate via OIDC" "expand/collapse" >}}

Create the following environment secrets in the `avm-validation` GitHub environment created at [Step 1](#1-fork-the-module-source-repository)

| Secret Name | Example | Description |
| - | - | - |
| `VALIDATE_CLIENT_ID` | `44444444-4444-4444-4444-444444444444` | The login credentials of the deployment principal used to log into the target Azure environment to test in. The format is described [here](https://github.com/Azure/login#configure-deployment-credentials). |
| `VALIDATE_SUBSCRIPTION_ID` | `22222222-2222-2222-2222-222222222222` | Same as the `ARM_SUBSCRIPTION_ID` repository secret set up above. The ID of the subscription to test-deploy modules in. Is needed for resources that are deployed to the subscription scope. |
| `VALIDATE_TENANT_ID` | `33333333-3333-3333-3333-333333333333` | Same as the `ARM_TENANT_ID` repository secret set up above. The tenant ID of the Azure Active Directory tenant to test-deploy modules in. Is needed for resources that are deployed to the tenant scope. |

{{< expand "➕ How to: Add an environment secret to GitHub" "expand/collapse" >}}

1. Navigate to the repository's `Settings`.

    <img src="../../../img/bicep-ci/forkSettings.png" alt="Navigate to settings" width=100%>

2. In the list of settings, select `Environments`. Click on the previously created `avm-validation` environment.

    <img src="../../../img/bicep-ci/forkSettingsEnvironmentConfigure.png" alt="Navigate to environments" width=100%>

3. In the `Environment secrets` Section click on the `Add environment secret` button.

    <img src="../../../img/bicep-ci/forkSettingsEnvironmentSecretAdd.png" alt="Navigate to env secrets" width=70%>

4. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.

    <img src="../../../img/bicep-ci/forkSettingsEnvironmentSecretAdd_02.png" alt="Add env secret" width=100%>

{{< /expand >}}

{{< /expand >}}

{{< expand "➕ Option 2 [Deprecated]: Authenticate via Service Principal + Secret" "expand/collapse" >}}

Create the following environment repository secret:

| Secret Name  | Example | Description |
| - | - | - |
| `AZURE_CREDENTIALS` | `{"clientId": "44444444-4444-4444-4444-444444444444", "clientSecret": "<placeholder>", "subscriptionId": "22222222-2222-2222-2222-222222222222", "tenantId": "33333333-3333-3333-3333-333333333333" }` | The login credentials of the deployment principal used to log into the target Azure environment to test in. The format is described [here](https://github.com/Azure/login#configure-deployment-credentials). For more information, see the `[Special case: AZURE_CREDENTIALS]` note below. |

{{< hint type=important title="Special case: AZURE_CREDENTIALS">}}

This secret represent the service connection to Azure, and its value is a compressed JSON object that must match the following format:

```JSON
{"clientId": "<client_id>", "clientSecret": "<client_secret>", "subscriptionId": "<subscriptionId>", "tenantId": "<tenant_id>" }
```

**Make sure you create this object as one continuous string as shown above** - using the information you collected during [Step 2](#2-configure-a-deployment-identity-in-azure). Failing to format the secret as above, causes GitHub to consider each line of the JSON object as a separate secret string. If you're interested, you can find more information about this object [here](https://github.com/Azure/login#configure-deployment-credentials).

{{< /hint >}}

{{< /expand >}}

<p>


### 3.2. Enable actions

Finally, 'GitHub Actions' are disabled by default and hence, must be enabled first.

To do so, perform the following steps:

1. Navigate to the `Actions` tab on the top of the repository page.

1. Next, select '`I understand my workflows, go ahead and enable them`'.

<img src="../../../img/bicep-ci/actionsEnable.png" alt="Enable Actions" width=100%>

### 3.3. Set Read/Write Workflow permissions

To let the workflow engine publish their results into your repository, you have to enable the read / write access for the GitHub actions.

1. Navigate to the `Settings` tab on the top of your repository page.

1. Within the section `Code and automation` click on `Actions` and `General`

1. Make sure to enable `Read and write permissions`

<img src="../../../img/bicep-ci/workflow_permissions.png" alt="Workflow Permissions" width=100%>

<br>

{{< hint type=tip >}}

Once you enabled the GitHub actions, your workflows will behave as they do in the upstream repository. This includes a scheduled trigger to continuously check that all modules are working and compliant with the latest tests. However, testing all modules can incur substantial costs with the target subscription. Therefore, we recommend **disabling all workflows of modules you are not working on**. To make this as easy as possible, we created a workflow that disables/enables workflows based on a selected toggle & naming pattern. For more information on how to use this workflow, please refer to the corresponding [documentation](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows).

{{< /hint >}}

## 4. Implement your contribution

To implement your contribution, we kindly ask you to first review the [Bicep specifications](/Azure-Verified-Modules/specs/bcp/) and [composition guidelines](/Azure-Verified-Modules/contributing/bicep/composition/) in particular to make sure your contribution complies with the repository's design and principles.

If you're working on a new module, we'd also ask you to create its corresponding workflow file. Each module has its own file, but only differs in very few details, such as its triggers and pipeline variables. As a result, you can either copy & update any other module workflow file (starting with `'avm.[res|ptn|utl].'`) or leverage the following template:

{{< expand "➕ Module workflow template" "expand/collapse" >}}

{{< include file="/static/includes/avm.workflow.template.yml" language="yaml" options="linenos=false" >}}

{{< /expand >}}

{{< hint type=tip >}}

After any change to a module and before running tests, we highly recommend running the [Set-AVMModule](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files) utility to update all module files that are auto-generated (e.g., the `main.json` & `readme.md` files).

{{< /hint >}}

<br>

## 5. Create/Update and run tests

Before opening a Pull Request to the Bicep Public Registry, ensure your module is ready for publishing, by validating that it meets all the Testing Specifications as per [SNFR1](/Azure-Verified-Modules/spec/SNFR1), [SNFR2](/Azure-Verified-Modules/spec/SNFR2), [SNFR3](/Azure-Verified-Modules/spec/SNFR3), [SNFR4](/Azure-Verified-Modules/spec/SNFR4), [SNFR5](/Azure-Verified-Modules/spec/SNFR5), [SNFR6](/Azure-Verified-Modules/spec/SNFR6), [SNFR7](/Azure-Verified-Modules/spec/SNFR7).

For example, to meet [SNFR2](/Azure-Verified-Modules/specc/SNFR2), ensure the updated module is deployable against a testing Azure subscription and compliant with the intended configuration.

Depending on the type of contribution you implemented (for example, a new resource module feature) we would kindly ask you to also update the `e2e` test run by the pipeline. For a new parameter this could mean to either add its usage to an existing test file, or to add an entirely new test as per [BCPRMNFR1](/Azure-Verified-Modules/spec/BCPRMNFR1).

Once the contribution is implemented and the changes are pushed to your forked repository, we kindly ask you to validate your updates in your own cloud environment before requesting to merge them to the main repo. Test your code leveraging the forked AVM CI environment you configured before

{{< hint type=tip >}}

In case your contribution involves changes to a module, you can also optionally leverage the [Validate module locally](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally) utility to validate the updated module from your local host before validating it through its pipeline.

{{< /hint >}}

### Creating `e2e` tests

As per [BCPRMNFR1](/Azure-Verified-Modules/spec/BCPRMNFR1), a resource module must contain a minimum set of deployment test cases, while for pattern modules there is no restriction on the naming each deployment test must have.
In either case, you're free to implement any additional, meaningful test that you see fit. Each test is implemented in its own test folder, containing at least a `main.test.bicep` and optionally any amount of extra deployment files that you may require (e.g., to deploy dependencies using a `dependencies.bicep` that you reference in the test template file).

To get started implementing your test in the `main.test.bicep` file, we recommend the following guidelines:

- As per [BCPNFR13](/Azure-Verified-Modules/spec/BCPNFR13), each `main.test.bicep` file should implement metadata to render the test more meaningful in the documentation
- The `main.test.bicep` file should deploy any immediate dependencies (e.g., a resource group, if required) and invoke the module's main template while providing all parameters for a given test scenario.
- Parameters

  - Each file should define a parameter `serviceShort`. This parameter should be unique to this file (i.e, no two test files should share the same) as it is injected into all resource deployments, making them unique too and account for corresponding requirements.

    - As a reference you can create a identifier by combining a substring of the resource type and test scenario (e.g., in case of a Linux Virtual Machine Deployment: `vmlin`).
    - For the substring, we recommend to take the first character and subsequent 'first' character from the resource type identifier and combine them into one string. Following you can find a few examples for reference:

      - `db-for-postgre-sql/flexible-server` with a test folder `default` could be: `dfpsfsdef`
      - `storage/storage-account` with a test folder `waf-aligned` could be: `ssawaf`

      💡 If the combination of the `servicesShort` with the rest of a resource name becomes too long, it may be necessary to bend the above recommendations and shorten the name.
      This can especially happen when deploying resources such as Virtual Machines or Storage Accounts that only allow comparatively short names.

  - If the module deploys a resource-group-level resource, the template should further have a `resourceGroupName` parameter and subsequent resource deployment. As a reference for the default name you can use `dep-<namePrefix><providerNamespace>.<resourceType>-${serviceShort}-rg`.
  - Each file should also provide a `location` parameter that may default to the deployments default location

- It is recommended to define all major resource names in the `main.test.bicep` file as it makes later maintenance easier. To implement this, make sure to pass all resource names to any referenced module (including any resource deployed in the `dependencies.bicep`).
- Further, for any test file (including the `dependencies.bicep` file), the usage of variables should be reduced to the absolute minimum. In other words: You should only use variables if you must use them in more than one place. The idea is to keep the test files as simple as possible
- References to dependencies should be implemented using resource references in combination with outputs. In other words: You should not hardcode any references into the module template's deployment. Instead use references such as `nestedDependencies.outputs.managedIdentityPrincipalId`

  {{< hint type=important >}}

  As per [BCPNFR12](/Azure-Verified-Modules/spec/BCPNFR12) you must use the header `module testDeployment '../.*main.bicep' =` when invoking the module's template.

  {{< /hint >}}

  {{< hint type=tip >}}

  📜 [Example of test file](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/tools/helper/src/src.main.test.bicep)

  {{< /hint >}}

Dependency file (`dependencies.bicep`) guidelines:

- The `dependencies.bicep` should optionally be used if any additional dependencies must be deployed into a nested scope (e.g. into a deployed Resource Group).
- Note that you can reuse many of the assets implemented in other modules. For example, there are many recurring implementations for Managed Identities, Key Vaults, Virtual Network deployments, etc.

- A special case to point out is the implementation of Key Vaults that require purge protection (for example, for Customer Managed Keys). As this implies that we cannot fully clean up a test deployment, it is recommended to generate a new name for this resource upon each pipeline run using the output of the `utcNow()` function at the time.

  {{< hint type=tip >}}

  📜 [Example of test using purge protected Key Vault dependency](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cognitive-services/account/tests/e2e/system-assigned-cmk-encryption/main.test.bicep#L43)

  {{< /hint >}}

<br>

  {{< hint type=tip >}}

  📜 If your test case requires any value that you cannot / should not specify in the test file itself (e.g., tenant-specific object IDs or secrets), please refer to the [Custom CI secrets](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/custom-ci-secrets) feature.

  {{< /hint >}}

### Reusable assets

There are a number of additional scripts and utilities available [here](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/e2e-template-assets) that may be of use to module owners/contributors. These contain both scripts and Bicep templates that you can re-use in your test files (e.g., to deploy standadized dependencies, or to generate keys using deployment scripts).

<u><b>Example:</b> Certificate creation script</u>

If you need a Deployment Script to set additional non-template resources up (for example certificates/files, etc.), we recommend to store it as a file in the shared `utilities/e2e-template-assets/scripts` folder and load it using the template function `loadTextContent()` (for example: `scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')`). This approach makes it easier to test & validate the logic and further allows reusing the same logic across multiple test cases.

<u><b>Example:</b> Diagnostic Settings dependencies</u>

To test the numerous diagnostic settings targets (Log Analytics Workspace, Storage Account, Event Hub, etc.) the AVM core team have provided a dependencies `.bicep` file to help create all these pre-requisite targets that will be needed during test runs.

{{< expand "➕ Diagnostic Settings Dependencies - Bicep File" "expand/collapse" >}}

{{< include file="/static/includes/diagnostic.dependencies.bicep" language="bicep" options="linenos=false" >}}

{{< /expand >}}

<br>

## 6. Create a Pull Request to the Public Bicep Registry

Finally, once you are satisfied with your contribution and validated it, open a PR for the module owners or core team to review. Make sure you:

1. Provide a meaningful title in the form of _feat: `<module name>`_ to align with the Semantic PR Check.
2. Provide a meaningful description.
3. Follow instructions you find in the PR template.
4. If applicable (i.e., a module is created/updated), please reference the badge status of your pipeline run. This badge will show the reviewer that the code changes were successfully validated & tested in your environment. To create a badge, first select the three dots (`...`) at the top right of the pipeline, and then chose the `Create status badge` option.

    <img src="../../../img/contribution/badgeDropdown.png" alt="Badge dropdown" height="200">

    In the opening pop-up, you first need to select your branch and then click on the `Copy status badge Markdown`

    <img src="../../../img/contribution/pipelineBadge.png" alt="Status Badge" height="400">

{{< hint type=note >}}

If you're the **sole owner of the module**, the **AVM core team must review and approve the PR**. To indicate that your PR needs the core team's attention, **apply the** "<mark style="background-color:#DB4503;color:white;">Needs: Core Team 🧞</mark>" **label on it!**

{{< /hint >}}

<!--
## Publishing to the Registry

When the AVM Modules are published to the Bicep Public Registry they **MUST** follow the below requirements:

- Resource Module: `avm/res/<rp>/<resource type>` as per [RMNFR1](/Azure-Verified-Modules/specRMNFR1)
- Pattern Module: `avm/ptn/<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/spec/PMNFR1)

This will require the alias on the MCR to be different than the directory path, which is the default for BRM today.

***Guidance will be provided below on how to do this, when available.***
-->
