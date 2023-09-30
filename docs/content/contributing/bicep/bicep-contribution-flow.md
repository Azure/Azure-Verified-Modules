---
title: Bicep Contribution Flow
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}

<!--
TODO: Should contain

Flow: External contributor
- Navigating to repo
- Fork
- Setting up CI environment
- Create IP (Module/Pattern)
- Testing
- Create Pull request & attach pipeline badge

Flow: Module Owner
?
-->

## Repositories

Bicep AVM Modules (both Resource and Pattern modules) will be homed in the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and live within an `avm` directory that will be located at the root of the repository, as per [SNFR19](/Azure-Verified-Modules/specs/shared/#id-snfr19---category-publishing---registries-targeted).

Module owners are expected to fork the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository and work on a branch from within their fork, before then creating a Pull Request (PR) back into the [`Azure/bicep-registry-modules`](https://github.com/Azure/bicep-registry-modules) repository's `main` branch.

## Setting up your CI environment

Contributing to the AVM Bicep modules requires several steps:

- [Repositories](#repositories)
- [Setting up your CI environment](#setting-up-your-ci-environment)
  - [1. Configure your Azure environment](#1-configure-your-azure-environment)
  - [2. Fork the Public Bicep Registry repository](#2-fork-the-public-bicep-registry-repository)
  - [3. Configure the CI environment](#3-configure-the-ci-environment)
  - [3.1 Set up secrets](#31-set-up-secrets)
  - [3.2 Enable actions](#32-enable-actions)
  - [3.3 Set R/W Workflow permissions](#33-set-rw-workflow-permissions)
- [Testing](#testing)
  - [Testing Diagnostic Settings](#testing-diagnostic-settings)
- [Publishing to the Registry](#publishing-to-the-registry)

### 1. Configure your Azure environment

AVM tests the deployments in an Azure subscription. To do so, it requires a service principal with access to it.

In this first step, make sure you
- Have/create an Azure Active Directory Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You might find the following links useful:
  - [Create a service principal (Azure Portal)](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-create-service-principal-portal)
  - [Create a service principal (PowerShell)](https://learn.microsoft.com/en-us/azure/active-directory/develop/howto-authenticate-service-principal-powershell)
  - [Find Service Principal object ID](https://cloudsight.zendesk.com/hc/en-us/articles/360016785598-Azure-finding-your-service-principal-object-ID)
  - [Find managed Identity Service Principal](https://learn.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/how-to-view-managed-identity-service-principal-portal)
- Note down the following pieces of information
  - Application (Client) ID
  - Service Principal Object ID (**not** the object ID of the application)
  - Service Principal Secret (password)
  - Tenant ID
  - Subscription ID
  - Parent Management Group ID

> **Note:** The Service Principal must be able to query its own details in the Azure Active Directory (AAD). To that end, ensure it has at least the (default) role 'Cloud application administrator'.

### 2. Fork the Public Bicep Registry repository

Next, you'll want to create your own fork of repository. To do so, simply navigate to the [Public Bicep Registry](https://github.com/Azure/bicep-registry-modules) repository, select the `'Fork'` button to the top right of the UI, select where the fork should be created (i.e., the owning organization) and finally click 'Create fork'.

### 3. Configure the CI environment

To configure the CI environment you have to perform several steps:
- [3.1 Set up secrets](#31-set-up-secrets)
- [3.2 Enable actions](#32-enable-actions)
- [3.3 Set R/W Workflow permissions](#33-set-rw-workflow-permissions)

### 3.1 Set up secrets

To use the environment's pipelines you should use the information you gathered during the [Azure setup](#1-configure-your-azure-environment) to set up the following repository secrets:

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `11111111-1111-1111-1111-111111111111` | The group ID of the management group to test-deploy modules in. |
| `ARM_SUBSCRIPTION_ID` | `22222222-2222-2222-2222-222222222222` | The ID of the subscription to test-deploy modules in. |
| `ARM_TENANT_ID` | `33333333-3333-3333-3333-333333333333` | The tenant ID of the Azure Active Directory tenant to test-deploy modules in. |
| `AZURE_CREDENTIALS` | `{"clientId": "44444444-4444-4444-4444-444444444444", "clientSecret": "<placeholder>", "subscriptionId": "22222222-2222-2222-2222-222222222222", "tenantId": "33333333-3333-3333-3333-333333333333" }` | The login credentials of the deployment principal used to log into the target Azure environment to test in. The format is described [here](https://github.com/Azure/login#configure-deployment-credentials). For more information, see the `[Special case: AZURE_CREDENTIALS]` note below. |
| `TOKEN_NAMEPREFIX` | `cntso` | Optional. A short (3-5 character length), unique string that should be included in any deployment to Azure. For more information, see the `[Special case: TOKEN_NAMEPREFIX]` note below. |

<p>

<details>
<summary><b>How to:</b> Add a repository secret to GitHub</summary>

1. Navigate to the repository's `Settings`.

    <img src="../../../img/bicep-ci/forkSettings.png" alt="Navigate to settings" width=100%>

1. In the list of settings, expand `Secrets` and select `Actions`. You can create a new repository secret by selecting `New repository secret` on the top right.

    <img src="../../../img/bicep-ci/forkSettingsSecrets.png" alt="Navigate to secrets" width=100%>

1. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.

    <img src="../../../img/bicep-ci/forkSettingsSecretAdd.png" alt="Add secret" width=100%>

</details>

<p>

> Special case: `AZURE_CREDENTIALS`, </br>
> This secret represent the service connection to Azure, and its value is a compressed JSON object that must match the following format:
>
> ```JSON
> {"clientId": "<client_id>", "clientSecret": "<client_secret>", "subscriptionId": "<subscriptionId>", "tenantId": "<tenant_id>" }
> ```
>
> **Make sure you create this object as one continuous string as shown above** - using the information you collected during [Step 1](#1-configure-your-azure-environment). Failing to format the secret as above, causes GitHub to consider each line of the JSON object as a separate secret string. If you're interested, you can find more information about this object [here](https://github.com/Azure/login#configure-deployment-credentials).

> Special case: `TOKEN_NAMEPREFIX`, </br>
> To lower the barrier to entry and allow users to easily define their own naming conventions, we introduced a default `'name prefix'` for all deployed resources.
>
>> **Note:** This prefix is only used by the CI environment you validate your modules in, and doesn't affect the naming of any resources you deploy as part of any multi-module solutions (applications/workloads) based on the modules.
>
> Each pipeline in AVM deploying resources uses a logic that automatically replaces "tokens" (i.e., placeholders) in any module test file. These tokens are, for example, included in the resources names (e.g. `'name: kvlt-${namePrefix}'`). Tokens are stored as repository secrets to facilitate maintenance.

### 3.2 Enable actions

Finally, 'GitHub Actions' are disabled by default and hence, must be enabled first.

To do so, perform the following steps:

1. Navigate to the `Actions` tab on the top of the repository page.

1. Next, select '`I understand my workflows, go ahead and enable them`'.

    <img src="../../../img/bicep-ci/actionsEnable.png" alt="Enable Actions" width=100%>

### 3.3 Set R/W Workflow permissions

To let the workflow engine publish their results into your repository, you have to enable the read / write access for the GitHub actions.

1. Navigate to the `Settings` tab on the top of your repository page.

1. Within the section `Code and automation` click on `Actions` and `General`

1. Make sure to enable `Read and write permissions`

    <img src="../../../img/bicep-ci/workflow_permissions.png" alt="Workflow Permissions" width=100%>

<br>

## Testing

{{< hint type=note >}}

The AVM core team is working to provide a CI environment used for testing the AVM Bicep modules in the Public Bicep Registry. Until the automation is ready, we kindly ask contributors to proceed with local and manual testing from their fork.

{{< /hint >}}

Before opening a Pull Request to the Bicep Public Registry, ensure your module is ready for publishing, by validating that it meets all the Testing Specifications as per [SNFR1](/Azure-Verified-Modules/specs/shared/#id-snfr1---category-testing---prescribed-tests), [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing), [SNFR3](/Azure-Verified-Modules/specs/shared/#id-snfr3---category-testing---avm-unit-tests), [SNFR4](/Azure-Verified-Modules/specs/shared/#id-snfr4---category-testing---additional-unit-tests), [SNFR5](/Azure-Verified-Modules/specs/shared/#id-snfr5---category-testing---upgrade-tests), [SNFR6](/Azure-Verified-Modules/specs/shared/#id-snfr6---category-testing---static-analysislinting-tests), [SNFR7](/Azure-Verified-Modules/specs/shared/#id-snfr7---category-testing---idempotency-tests).

For example, to meet [SNFR2](/Azure-Verified-Modules/specs/shared/#id-snfr2---category-testing---e2e-testing), ensure the updated module is deployable against a testing Azure subscription and compliant with the intended configuration.

### Testing Diagnostic Settings

To test the numerous diagnostic settings targets (Log Analytics Workspace, Storage Account, Event Hub, etc.) the AVM core team have provided a dependencies `.bicep` file to help create all these pre-requisite targets that will be needed during test runs.

{{< expand "➕ Diagnostic Settings Dependencies - Bicep File" "expand/collapse" >}}

{{< include file="/static/includes/diagnostic.dependencies.bicep" language="bicep" options="linenos=false" >}}

{{< /expand >}}

{{< hint type=note >}}

Also note there are a number of additional scripts and utilities available [here](https://github.com/Azure/bicep-registry-modules/blob/main/avm/utilities/e2e-template-assets/templates/diagnostic.dependencies.bicep) that may be of use to module owners/contributors.

{{< /hint >}}

<br>

## Publishing to the Registry

When the AVM Modules are published to the Bicep Public Registry they **MUST** follow the below requirements:

- Resource Module: `avm-res-<rp>-<armresourcename>` as per [RMNFR1](/Azure-Verified-Modules/specs/shared/#id-rmnfr1---category-naming---module-naming)
- Pattern Module: `avm-ptn-<patternmodulename>` as per [PMNFR1](/Azure-Verified-Modules/specs/shared/#id-pmnfr1---category-naming---module-naming)

This will require the alias on the MCR to be different than the directory path, which is the default for BRM today.

***Guidance will be provided below on how to do this, when available.***
