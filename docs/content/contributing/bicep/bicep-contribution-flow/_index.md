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
    A(<a href='/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#1-setup-your-azure-test-environment'>1. Setup your Azure test environment </a>)
    B(<a href='/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#1-setup-your-azure-test-environment'>2. Fork the module source repository</a>)
    C(<a href='/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#3-configure-your-ci-environment'>3. Configure CI environment </a> <br> For module tests)
    D(<a href='/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#4-implement-your-contribution'>4. Implementing your contribution </a><br> Refer to Gitflow Diagram below)
    E{<a href='/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#5-createupdate-and-run-tests'>5. Workflow test <br> completed <br> successfully?</a>}
    F(<a href='/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/#6-create-a-pull-request-to-the-public-bicep-registry'>6. Create a pull request to the upstream repository</a>)
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

</br>

## 1. Setup your Azure test environment

{{< hint type=note >}}

Each time in the following sections we refer to 'your xzy', it is an indicator that you have to change something in your own environment.

{{< /hint >}}


AVM tests the deployments in an Azure subscription. To do so, it requires a service principal with access to it.

In this first step, make sure you
- Have/create an Azure Active Directory Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You might find the following links useful:
  - [Create a service principal (Azure Portal)](https://learn.microsoft.com/azure/active-directory/develop/howto-create-service-principal-portal)
  - [Create a service principal (PowerShell)](https://learn.microsoft.com/azure/active-directory/develop/howto-authenticate-service-principal-powershell)
  - [Find Service Principal object ID](https://learn.microsoft.com/azure/cost-management-billing/manage/assign-roles-azure-service-principals#find-your-spn-and-tenant-id)
  - [Find managed Identity Service Principal](https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/how-to-view-managed-identity-service-principal-portal)
- Note down the following pieces of information
  - Application (Client) ID
  - Service Principal Object ID (**not** the object ID of the application)
  - Service Principal Secret (password)
  - Tenant ID
  - Subscription ID
  - Parent Management Group ID

<br>

## 2. Fork the module source repository

Bicep AVM Modules (both Resource and Pattern modules) will be homed in the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and live within an `avm` directory that will be located at the root of the repository, as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

Module owners are expected to fork the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and work on a branch from within their fork, before then creating a Pull Request (PR) back into the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository's `main` branch.

To do so, simply navigate to the [Public Bicep Registry](https://github.com/Azure/bicep-registry-modules) repository, select the `'Fork'` button to the top right of the UI, select where the fork should be created (i.e., the owning organization) and finally click 'Create fork'.

<br>

## 3. Configure your CI environment

To configure the forked CI environment you have to perform several steps:
- [3.1 Set up secrets](#31-set-up-secrets)
- [3.2 Enable actions](#32-enable-actions)
- [3.3 Set Read/Write Workflow permissions](#33-set-readwrite-workflow-permissions)

### 3.1. Set up secrets

To use the environment's pipelines you should use the information you gathered during the [Azure setup](#1-setup-your-azure-test-environment) to set up the following repository secrets:

| Secret Name           | Example                                                                                                                                                                                                | Description                                                                                                                                                                                                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `ARM_MGMTGROUP_ID`    | `11111111-1111-1111-1111-111111111111`                                                                                                                                                                 | The group ID of the management group to test-deploy modules in.                                                                                                                                                                                                                            |
| `ARM_SUBSCRIPTION_ID` | `22222222-2222-2222-2222-222222222222`                                                                                                                                                                 | The ID of the subscription to test-deploy modules in.                                                                                                                                                                                                                                      |
| `ARM_TENANT_ID`       | `33333333-3333-3333-3333-333333333333`                                                                                                                                                                 | The tenant ID of the Azure Active Directory tenant to test-deploy modules in.                                                                                                                                                                                                              |
| `AZURE_CREDENTIALS`   | `{"clientId": "44444444-4444-4444-4444-444444444444", "clientSecret": "<placeholder>", "subscriptionId": "22222222-2222-2222-2222-222222222222", "tenantId": "33333333-3333-3333-3333-333333333333" }` | The login credentials of the deployment principal used to log into the target Azure environment to test in. The format is described [here](https://github.com/Azure/login#configure-deployment-credentials). For more information, see the `[Special case: AZURE_CREDENTIALS]` note below. |
| `TOKEN_NAMEPREFIX`    | `cntso`                                                                                                                                                                                                | Optional. A short (3-5 character length), unique string that should be included in any deployment to Azure. For more information, see the `[Special case: TOKEN_NAMEPREFIX]` note below.                                                                                                   |

<p>

{{< expand "➕ How to: Add a repository secret to GitHub" "expand/collapse" >}}

1. Navigate to the repository's `Settings`.

    <img src="../../../img/bicep-ci/forkSettings.png" alt="Navigate to settings" width=100%>

2. In the list of settings, expand `Secrets` and select `Actions`. You can create a new repository secret by selecting `New repository secret` on the top right.

    <img src="../../../img/bicep-ci/forkSettingsSecrets.png" alt="Navigate to secrets" width=100%>

3. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.

    <img src="../../../img/bicep-ci/forkSettingsSecretAdd.png" alt="Add secret" width=100%>

{{< /expand >}}

<p>

{{< hint type=important title="Special case: AZURE_CREDENTIALS">}}

This secret represent the service connection to Azure, and its value is a compressed JSON object that must match the following format:

```JSON
{"clientId": "<client_id>", "clientSecret": "<client_secret>", "subscriptionId": "<subscriptionId>", "tenantId": "<tenant_id>" }
```

**Make sure you create this object as one continuous string as shown above** - using the information you collected during [Step 1](#1-setup-your-azure-test-environment). Failing to format the secret as above, causes GitHub to consider each line of the JSON object as a separate secret string. If you're interested, you can find more information about this object [here](https://github.com/Azure/login#configure-deployment-credentials).

{{< /hint >}}

{{< hint type=note title-="Special case: TOKEN_NAMEPREFIX">}}

To lower the barrier to entry and allow users to easily define their own naming conventions, we introduced a default 'name prefix' for all deployed resources.

This prefix is **only** used by the CI environment you validate your modules in, and doesn't affect the naming of any resources you deploy as part of any multi-module solutions (applications/workloads) based on the modules.

Each pipeline in AVM deploying resources uses a logic that automatically replaces "tokens" (i.e., placeholders) in any module test file. These tokens are, for example, included in the resources names (e.g. `'name: kvlt-${namePrefix}'`). Tokens are stored as repository secrets to facilitate maintenance.

{{< /hint >}}

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

## 4. Implement your contribution

To implement your contribution, we kindly ask you to first review the [shared](/Azure-Verified-Modules/specs/shared/) & [Bicep-specific](/Azure-Verified-Modules/specs/bicep/) specifications and [composition guidelines](/Azure-Verified-Modules/contributing/bicep/composition/) in particular to make sure your contribution complies with the repository's design and principles.

If you're working on a new module, we'd also ask you to create its corresponding workflow file. Each module has its own file, but only differs in very few details, such as its triggers and pipeline variables. As a result, you can either copy & update any other module workflow file (starting with `'avm.[res|ptn].'`) or leverage the following template:

{{< expand "➕ Module workflow template" "expand/collapse" >}}

{{< include file="/static/includes/avm.[res-res].template.pattern.yml" language="yaml" options="linenos=false" >}}

{{< /expand >}}

{{< hint type=tip >}}

After any change to a module and before running tests, we highly recommend running the [Set-AVMModule](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files) utility to update all module files that are auto-generated (e.g., the `main.json` & `readme.md` files).

{{< /hint >}}

<br>

## 5. Create/Update and run tests

Before opening a Pull Request to the Bicep Public Registry, ensure your module is ready for publishing, by validating that it meets all the Testing Specifications as per [SNFR1](/Azure-Verified-Modules/specs/shared/#id-snfr1---category-testing---prescribed-tests), [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing), [SNFR3](/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-unit-tests), [SNFR4](/Azure-Verified-Modules/specs/shared/#id-snfr4---category-testing---additional-unit-tests), [SNFR5](/Azure-Verified-Modules/specs/shared/#id-snfr5---category-testing---upgrade-tests), [SNFR6](/Azure-Verified-Modules/specs/shared/#id-snfr6---category-testing---static-analysislinting-tests), [SNFR7](/Azure-Verified-Modules/specs/shared/#id-snfr7---category-testing---idempotency-tests).

For example, to meet [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing), ensure the updated module is deployable against a testing Azure subscription and compliant with the intended configuration.

Depending on the type of contribution you implemented (for example, a new module feature) we would kindly ask you to also update the `e2e` test run by the pipeline. For a new parameter this could mean to either add its usage to an existing test file, or to add an entirely new test as per [BCPNFR9](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr9---category-testing---expected-test-directories).

Once the contribution is implemented and the changes are pushed to your forked repository, we kindly ask you to validate your updates in your own cloud environment before requesting to merge them to the main repo. Test your code leveraging the forked AVM CI environment you configured before

{{< hint type=tip >}}

In case your contribution involves changes to a module, you can also optionally leverage the [Validate module locally](/Azure-Verified-Modules/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally) utility to validate the updated module from your local host before validating it through its pipeline.

{{< /hint >}}

### Creating `e2e` tests

As per [BCPNFR9](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr9---category-testing---expected-test-directories), the module must contain a minimum set of deployment test cases, but beyond those you're free to implement any additional, meaningful test that you see fit. Each test is implemented in its own test folder, containing at least a `main.test.bicep` and optionally any amount of extra deployment files that you may require (e.g., to deploy dependencies using a `dependencies.bicep` that you reference in the test template file).

To get started implementing your test in the `main.test.bicep` file, we recommend the following guidelines:

- As per [BCPNFR13](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr13---category-testing---test-file-metadata), each `main.test.bicep` file should implement metadata to render the test more meaningful in the documentation
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

  As per [BCPNFR12](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr12---category-testing---deployment-test-naming) you must use the header `module testDeployment '../.*main.bicep' =` when invoking the module's template.

  {{< /hint >}}

  {{< hint type=tip >}}

  📜 [Example of test file](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/tools/helper/src/src.main.test.bicep)

  {{< /hint >}}

Dependency file (`dependencies.bicep`) guidelines:

- The `dependencies.bicep` should optionally be used if any additional dependencies must be deployed into a nested scope (e.g. into a deployed Resource Group).
- Note that you can reuse many of the assets implemented in other modules. For example, there are many recurring implementations for Managed Identities, Key Vaults, Virtual Network deployments, etc.

- A special case to point out is the implementation of Key Vaults that require purge protection (for example, for Customer Managed Keys). As this implies that we cannot fully clean up a test deployment, it is recommended to generate a new name for this resource upon each pipeline run using the output of the `utcNow()` function at the time.

  {{< hint type=tip >}}

  📜 [Example of test using purge protected Key Vault dependency](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cognitive-services/account/tests/e2e/system-assigned-cmk-encryption/main.test.bicep#L43)

  {{< /hint >}}

<br>

### Reusable assets

There are a number of additional scripts and utilities available [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/e2e-template-assets) that may be of use to module owners/contributors. These contain both scripts and Bicep templates that you can re-use in your test files (e.g., to deploy standadized dependencies, or to generate keys using deployment scripts).

<u><b>Example:</b> Certificate creation script</u>

If you need a Deployment Script to set additional non-template resources up (for example certificates/files, etc.), we recommend to store it as a file in the shared `avm/utilities/e2e-template-assets/scripts` folder and load it using the template function `loadTextContent()` (for example: `scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')`). This approach makes it easier to test & validate the logic and further allows reusing the same logic across multiple test cases.

<u><b>Example:</b> Diagnostic Settings dependencies</u>

To test the numerous diagnostic settings targets (Log Analytics Workspace, Storage Account, Event Hub, etc.) the AVM core team have provided a dependencies `.bicep` file to help create all these pre-requisite targets that will be needed during test runs.

{{< expand "➕ Diagnostic Settings Dependencies - Bicep File" "expand/collapse" >}}

{{< include file="/static/includes/diagnostic.dependencies.bicep" language="bicep" options="linenos=false" >}}

{{< /expand >}}

<br>

## 6. Create a Pull Request to the Public Bicep Registry

Finally, once you are satisfied with your contribution and validated it, open a PR for the module owners or core team to review. Make sure you:

1. Provide a meaningful title
1. Provide a meaningful description.
1. Follow instructions you find in the PR template.
1. If applicable (i.e., a module is created/updated), please reference the badge status of your pipeline run. This badge will show the reviewer that the code changes were successfully validated & tested in your environment. To create a badge, first select the three dots (`...`) at the top right of the pipeline, and then chose the `Create status badge` option.

<img src="../../../img/contribution/badgeDropdown.png" alt="Badge dropdown" height="200">

In the opening pop-up, you first need to select your branch and then click on the `Copy status badge Markdown`

<img src="../../../img/contribution/pipelineBadge.png" alt="Status Badge" height="400">

<!--
## Publishing to the Registry

When the AVM Modules are published to the Bicep Public Registry they **MUST** follow the below requirements:

- Resource Module: `avm/res/<rp>/<resource type>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `avm/ptn/<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

This will require the alias on the MCR to be different than the directory path, which is the default for BRM today.

***Guidance will be provided below on how to do this, when available.***
-->
