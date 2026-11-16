---
title: Bicep Contribution Flow
linktitle: Contribution Flow
description: Bicep Contribution Flow for the Azure Verified Modules (AVM) program
---

{{% notice style="important" %}}
If you are a **Bicep module owner**, also complete the [Owner Contribution Flow]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/owner-contribution-flow/), including requesting the [AVM Module Contributors access package](https://aka.ms/avm/id/access-package/module-contributor). Contributors who are not module owners do not need this owner access.
{{% /notice %}}

## High-level contribution flow

{{< mermaid zoom="false">}}

---
config:
  nodeSpacing: 20
  rankSpacing: 20
  diagramPadding: 50
  padding: 5
  flowchart:
    wrappingWidth: 300
    padding: 5
  layout: elk
  elk:
    mergeEdges: true
    nodePlacementStrategy: LINEAR_SEGMENTS
---

flowchart TD
  A("1 - Fork [optional for external contributors]")
    click A "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#1-fork-optional"
  B(2 - Branch)
    click B "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#2-branch"
  C(3 - Implement your code change)
    click C "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#3-implement-your-code-change"
  D(4 - Run avm pre-commit)
    click D "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#4-run-avm-pre-commit"
  E(5 - Run checks and tests)
    click E "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#5-run-checks-and-tests-locally"
  F(6 - Raise or update PR)
    click F "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#6-raise-or-update-pr"
  G(7 - Approve and monitor CI tests)
    click G "{{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#7-approve-and-monitor-ci-tests"
  A --> B
  B --> C
  C --> D
  D --> E
  E --> F
  F --> G
  G --> H(8 - Review and merge PR)
  H --> I(9 - Module release)

{{< /mermaid >}}

## Working with branches and forks

Microsoft FTEs must work in the upstream repository and create a branch; do not fork. External contributors without write access can use a fork and an anchor branch to synchronize it with upstream `main`.

{{< mermaid zoom="true" >}}
---

config:
  logLevel: debug
  gitGraph:
    rotateCommitLabel: false
---

gitGraph LR:
  commit id:"External fork"
  branch anchor
  checkout anchor
  commit id:"Sync Upstream/main" type: HIGHLIGHT
  branch avm-type-provider-resource
  checkout avm-type-provider-resource
  commit id:"Init"
  commit id:"Patch 1"
  commit id:"Patch 2"
  checkout main
  merge avm-type-provider-resource
{{< /mermaid >}}

{{% notice style="tip" %}}

When using a fork, configure an `upstream` remote so you can sync with the upstream repository. This is not needed for FTEs working directly in the upstream repository.

{{% /notice %}}

The shared PR check runs against every contribution. FTEs can request deployment tests directly from their PR. An external fork PR does not run deployment tests through the label; follow the release-branch handoff only when that PR needs E2E testing.

## 1. Fork [optional]

This step is for external contributors who do not have write access to the upstream repository. Microsoft FTEs must not fork; go directly to [step 2](#2-branch) and create a branch in the upstream `Azure/bicep-registry-modules` repository.

{{% notice style="note" %}}

The GitHub environment and credential setup below is optional and only applies if you choose to run tests in your own fork. It is not required for upstream PR checks or for an FTE to run E2E tests from their PR.

{{% /notice %}}

Bicep AVM Modules (Resource, Pattern and Utility modules) are located in the `/avm` directory of the [`Azure/bicep-registry-modules`](https://aka.ms/BRM) repository, as per [SNFR19]({{% siteparam base %}}/spec/SNFR19).

External contributors without write access may fork the [`Azure/bicep-registry-modules`](https://aka.ms/BRM) repository and create a branch in that fork before opening a PR to upstream `main`.

To do so, simply navigate to the [Public Bicep Registry](https://aka.ms/BRM) repository, select the `'Fork'` button to the top right of the UI, select where the fork should be created (i.e., the owning organization) and finally click 'Create fork'.

### 1.1 Optional: Configure your fork for local test runs

Create the `avm-validation` environment in your fork.

{{% expand title="➕ How to: Create an environment in GitHub" %}}

1. Navigate to the repository's `Settings`.

2. In the list of settings, expand `Environments`. You can create a new environment by selecting `New environment` on the top right.

3. In the opening view, provide `avm-validation` for the environment `Name`. Click on the `Configure environment` button.

![AddEnvironment]({{% siteparam base %}}/images/bicep-ci/forkSettingsEnvironmentAdd.png "Add environment")

Please ref the following link for additional details: [Creating an environment](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment#creating-an-environment)

{{% /expand %}}

### 1.2 Optional: Configure a deployment identity in Azure

AVM tests its modules via deployments in an Azure subscription. To do so, it requires a deployment identity with access to it.

{{% notice style="warning" title="Deprecating the Service Principal + Secret authentication method" %}}

Support for the 'Service Principal + Secret' authentication method has been deprecated and will be decommissioned in the future.

It is highly recommended to start leveraging Option 1 below to adopt OpenID Connect (OIDC) authentication and align with security best practices.

{{% /notice %}}

{{% expand title="➕ Option 1 [Recommended]: OIDC - Configure a federated identity credential" %}}

{{% notice style="warning" title="Using a Managed Identity for OIDC" %}}

Make sure to use a Managed Identity for OIDC as instructed below, **not** a Service Principal. Azure access token issued by Managed Identities is expected to have an expiration of 24 hours by default. With Service Principal, instead, it would be only 1 hour - which is not sufficient for many deployment pipelines.

For more information, please refer to the official [GitHub documentation](https://github.com/marketplace/actions/azure-login#login-with-openid-connect-oidc-recommended).

{{% /notice %}}

1. Create a new or leverage an existing user-assigned managed identity with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You may find creating an `Owner` role assignment is more efficient and avoids some validation failures for some modules. You might find the following links useful:
    - [Create a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities#create-a-user-assigned-managed-identity)
    - [Assign an appropriate role to your user-assigned managed identity](https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities#manage-access-to-user-assigned-managed-identities)

    ![OIDCIdentityRoles]({{% siteparam base %}}/images/bicep-ci/msiOIDCRole.png?width=100vw "OIDC identity roles")

{{% notice style="note" title="Additional roles" %}}

Some Azure resources may require additional roles to be assigned to the deployment identity. An example is the `avm/res/aad/domain-service` module, which requires the deployment identity to have the Domain Services Contributor Azure role to create the required Domain Services resources.

In those cases, for the first PR adding such modules to the public registry, we recommend the author to reach out to AVM maintainers or, alternatively, to [create a CI environment GitHub issue](https://github.com/Azure/bicep-registry-modules/issues/new?template=avm_ci_environment_issue.yml) in BRM, specifying the additional prerequisites. This ensures that the required additional roles get assigned in the upstream CI environment before the corresponding PR gets merged.

{{% /notice %}}
<!-- markdownlint-disable MD029 -->
2. Configure a federated identity credential on a user-assigned managed identity to trust tokens issued by GitHub Actions to your GitHub repository.
    - In the Microsoft Entra admin center, navigate to the user-assigned managed identity you created. Under `Settings` in the left nav bar, select `Federated credentials` and then `Add Credential`.
      ![OIDCFederatedCredentials]({{% siteparam base %}}/images/bicep-ci/msiOIDCAddFederatedIdentity_01.png?width=30vw "OIDC federated credentials")
    - In the Federated credential scenario dropdown box, select `GitHub Actions deploying Azure resources`
      ![OIDCScenario]({{% siteparam base %}}/images/bicep-ci/msiOIDCAddFederatedIdentity_02.png?width=40vw "OIDC scenario")
    - For the `Organization`, specify your GitHub organization name, for the `Repository` the value `bicep-registry-modules`.
    - For the `Entity` type, select `Environment` and specify the value `avm-validation`.
    - Add a Name for the federated credential, for example, `avm-gh-env-validation`.
    - The `Issuer`, `Audiences`, and `Subject identifier` fields auto-populate based on the values you entered.
    - Select `Add` to configure the federated credential.
      ![OIDCAdd]({{% siteparam base %}}/images/bicep-ci/msiOIDCAddFederatedIdentity_03.png?width=35vw "OIDC Add")
    - You might find the following links & information useful:
      - If configuring the federated credential via API (e.g. Bicep, PowerShell etc.), you will need the following information points that are configured automatically for you via the portal experience:
        - Issuer = `https://token.actions.githubusercontent.com`
        - Subject = `repo:<GitHub Org>/<GitHub Repo>:environment:avm-validation`
        - Audience = `api://AzureADTokenExchange` (although this is default in the API so not required to set)
      - [Configure a federated identity credential on a user-assigned managed identity](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust-user-assigned-managed-identity)
3. Note down the following pieces of information
    - Client ID
    - Tenant ID
    - Subscription ID
    - Parent Management Group ID
    ![OIDCInfo]({{% siteparam base %}}/images/bicep-ci/msiOIDCInfo.png?width=35vw "OIDC Info")
<!-- markdownlint-restore -->

Additional references:

- [Configure a federated identity credential](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect#prerequisites)
- [Azure login GitHub action - Login with OIDC](https://github.com/Azure/login?tab=readme-ov-file#login-with-openid-connect-oidc-recommended)


{{% /expand %}}

{{% expand title="➕ Option 2 [Deprecated]: Configure Service Principal + Secret" %}}

1. Create a new or leverage an existing Service Principal with at least `Contributor` & `User Access Administrator` permissions on the Management-Group/Subscription you want to test the modules in. You may find creating an `Owner` role assignment is more efficient and avoids some validation failures for some modules. You might find the following links useful:
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

{{% /expand %}}

### 1.3 Optional: Configure CI in your fork

To configure the forked CI environment you have to perform several steps:

- [1.3.1 Set up secrets](#131-set-up-secrets)
- [1.3.2 Enable actions](#132-enable-actions)
- [1.3.3 Set Read/Write Workflow permissions](#133-set-readwrite-workflow-permissions)

### 1.3.1 Set up secrets

#### Shared repository secrets

To use the _Continuous Integration_ environment's workflows you should set up the following repository secrets:

| Secret Name | Example | Description |
| - | - | - |
| `ARM_MGMTGROUP_ID` | `11111111-1111-1111-1111-111111111111` | The group ID of the management group to test-deploy modules in. Is needed for resources that are deployed to the management group scope. |
| `ARM_SUBSCRIPTION_ID` | `22222222-2222-2222-2222-222222222222` | The ID of the subscription to test-deploy modules in. Is needed for resources that are deployed to the subscription scope. Note: This repository secret will be deprecated in favor of the `VALIDATE_SUBSCRIPTION_ID` environment secret required by the OIDC authentication. |
| `ARM_TENANT_ID` | `33333333-3333-3333-3333-333333333333` | The tenant ID of the Azure Active Directory tenant to test-deploy modules in. Is needed for resources that are deployed to the tenant scope. Note: This repository secret will be deprecated in favor of the `VALIDATE_TENANT_ID` environment secret required by the OIDC authentication. |
| `TOKEN_NAMEPREFIX` | `cntso` | Required. A short (3-5 character length), unique string that should be included in any deployment to Azure. Usually, AVM Bicep test cases require this value to ensure no two contributors deploy resources with the same name - which is especially important for resources that require a globally unique name (e.g., Key Vault). These characters will be used as part of each resource's name during deployment. For more information, see the `[Special case: TOKEN_NAMEPREFIX]` note below. |

{{% notice style="note" title="Special case: TOKEN_NAMEPREFIX" %}}

To lower the barrier to entry and allow users to easily define their own naming conventions, we introduced a default 'name prefix' for all deployed resources.

This prefix is **only** used by the CI environment you validate your modules in, and doesn't affect the naming of any resources you deploy as part of any solutions (applications/workloads) based on the modules.

The deployment test receives the configured prefix as a parameter. Test templates can use it in resource names (for example, `'name: kvlt-${namePrefix}'`); CI does not replace text in the test source.

{{% /notice %}}

<p>

{{% expand title="➕ How to: Add a repository secret to GitHub" %}}

1. Navigate to the repository's `Settings`.

    ![NavigateToSettings]({{% siteparam base %}}/images/bicep-ci/forkSettings.png?width=40vw "Navigate to settings")
<br>

2. In the list of settings, expand `Secrets` and select `Actions`. You can create a new repository secret by selecting `New repository secret` on the top right.

    ![NavigateToSecrets]({{% siteparam base %}}/images/bicep-ci/forkSettingsSecrets.png?width=40vw "Navigate to secrets")
<br>

3. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.

    ![AddSecret]({{% siteparam base %}}/images/bicep-ci/forkSettingsSecretAdd.png?width=40vw "Add secret")

{{% /expand %}}

#### Authentication secrets

In addition to shared repository secrets detailed above, additional GitHub secrets are required to allow the deploying identity to authenticate to Azure.

Expand and follow the option corresponding to the deployment identity setup you configured in step 1.2.

{{% expand title="➕ Option 1 [Recommended]: Authenticate via OIDC" %}}

Create the following environment secrets in the `avm-validation` GitHub environment created in step 1.1.

| Secret Name | Example | Description |
| - | - | - |
| `VALIDATE_CLIENT_ID` | `44444444-4444-4444-4444-444444444444` | The login credentials of the deployment principal used to log into the target Azure environment to test in. See the [deployment credentials format](https://github.com/Azure/login#configure-deployment-credentials). |
| `VALIDATE_SUBSCRIPTION_ID` | `22222222-2222-2222-2222-222222222222` | Same as the `ARM_SUBSCRIPTION_ID` repository secret set up above. The ID of the subscription to test-deploy modules in. Is needed for resources that are deployed to the subscription scope. |
| `VALIDATE_TENANT_ID` | `33333333-3333-3333-3333-333333333333` | Same as the `ARM_TENANT_ID` repository secret set up above. The tenant ID of the Azure Active Directory tenant to test-deploy modules in. Is needed for resources that are deployed to the tenant scope. |

{{% expand title="➕ How to: Add an environment secret to GitHub" %}}

1. Navigate to the repository's `Settings`.

    ![NavigateToSettings]({{% siteparam base %}}/images/bicep-ci/forkSettings.png?width=40vw "Navigate to settings")
<br>

2. In the list of settings, select `Environments`. Click on the previously created `avm-validation` environment.

    ![NavigateToEnvironments]({{% siteparam base %}}/images/bicep-ci/forkSettingsEnvironmentConfigure.png "Navigate to environments")
<br>

3. In the `Environment secrets` Section click on the `Add environment secret` button.

    ![NavigateToEnvSecrets]({{% siteparam base %}}/images/bicep-ci/forkSettingsEnvironmentSecretAdd.png "Navigate to env secrets")
<br>

4. In the opening view, you can create a secret by providing a secret `Name`, a secret `Value`, followed by a click on the `Add secret` button.
    ![AddEnvSecret]({{% siteparam base %}}/images/bicep-ci/forkSettingsEnvironmentSecretAdd_02.png "Add env secret")
<br>

{{% /expand %}}

{{% /expand %}}

{{% expand title="➕ Option 2 [Deprecated]: Authenticate via Service Principal + Secret" %}}

Create the following environment repository secret:

| Secret Name | Example | Description |
| - | - | - |
| `AZURE_CREDENTIALS` | `{"clientId": "44444444-4444-4444-4444-444444444444", "clientSecret": "<placeholder>", "subscriptionId": "22222222-2222-2222-2222-222222222222", "tenantId": "33333333-3333-3333-3333-333333333333" }` | The login credentials of the deployment principal used to log into the target Azure environment to test in. See the [deployment credentials format](https://github.com/Azure/login#configure-deployment-credentials). For more information, see the `[Special case: AZURE_CREDENTIALS]` note below. |

{{% notice style="important" title="Special case: AZURE_CREDENTIALS" %}}

This secret represent the service connection to Azure, and its value is a compressed JSON object that must match the following format:

```JSON
{"clientId": "<client_id>", "clientSecret": "<client_secret>", "subscriptionId": "<subscriptionId>", "tenantId": "<tenant_id>" }
```

**Make sure you create this object as one continuous string as shown above** - using the information you collected in step 1.2. Failing to format the secret as above, causes GitHub to consider each line of the JSON object as a separate secret string. See the [deployment credentials format](https://github.com/Azure/login#configure-deployment-credentials) for more information.

{{% /notice %}}

{{% /expand %}}

#### Custom CI parameters

For test-specific template inputs, create GitHub Actions secrets or variables at repository scope or in the `avm-validation` environment. Prefer readable `CI_` names such as `CI_MY_SECRET` for `mySecret`; underscores after the prefix are ignored. Use `CI__` to preserve literal underscores in parameter names. Use secrets for private values and variables only for clearly non-sensitive configuration. These inputs are separate from the OIDC authentication secrets above.

See [Custom CI parameters]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/custom-ci-secrets) for parameter naming, secure handling, precedence, and migration from the deprecated `CI_KEY_VAULT_NAME` Key Vault fallback.

### 1.3.2 Enable actions

Finally, 'GitHub Actions' are disabled by default and hence, must be enabled first.

To do so, perform the following steps:

1. Navigate to the `Actions` tab on the top of the repository page.

1. Next, select '`I understand my workflows, go ahead and enable them`'.

    ![EnableActions]({{% siteparam base %}}/images/bicep-ci/actionsEnable.png?width=35vw "Enable Actions")

### 1.3.3 Set Read/Write Workflow permissions

To let the workflow engine publish their results into your repository, you have to enable the read / write access for the GitHub actions.

1. Navigate to the `Settings` tab on the top of your repository page.

1. Within the section `Code and automation` click on `Actions` and `General`

1. Make sure to enable `Read and write permissions`

    ![WorkflowPermissions]({{% siteparam base %}}/images/bicep-ci/workflow_permissions.png "Workflow Permissions")

{{% notice style="tip" %}}

Deployment tests can create Azure resources and incur costs. Use only an authorized test subscription, and see [GitHub Actions in Forks]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/enable-or-disable-workflows/) for fork-specific behavior.

{{% /notice %}}

## 2. Branch

Create a branch from the latest upstream `main`. Microsoft FTEs must use the upstream `Azure/bicep-registry-modules` repository and must not fork it. External contributors without write access can create the branch in their fork; first synchronize the fork's `main` with upstream.

## 3. Implement your code change

To implement your contribution, we kindly ask you to first review the [Bicep specifications]({{% siteparam base %}}/specs/bcp/) and [composition guidelines]({{% siteparam base %}}/contributing/bicep/composition/) in particular to make sure your contribution complies with the repository's design and principles.

For an approved new module, start with the [metadata-only proposed module guide]({{% siteparam base %}}/contributing/module-metadata/#create-only-metadata-for-an-approved-bicep-proposal) if its source is not ready, or [initialize the full module]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/) with `avm init`. The shared workflow discovers affected modules.


## 4. Run `avm pre-commit`

After editing Bicep source or tests, run [`avm pre-commit`]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/generate-bicep-module-files/#update-generated-files-after-editing) on the module directory. It validates, formats, builds, and updates generated `main.json` and `README.md` files for the module and its children. This local command does not replace PR checks.

## 5. Run checks and tests locally

Before opening a Pull Request to the Bicep Public Registry, ensure your module is ready for publishing, by validating that it meets all the Testing Specifications as per [SNFR1]({{% siteparam base %}}/spec/SNFR1), [SNFR2]({{% siteparam base %}}/spec/SNFR2), [SNFR3]({{% siteparam base %}}/spec/SNFR3), [SNFR4]({{% siteparam base %}}/spec/SNFR4), [SNFR5]({{% siteparam base %}}/spec/SNFR5), [SNFR6]({{% siteparam base %}}/spec/SNFR6), [SNFR7]({{% siteparam base %}}/spec/SNFR7).

For example, to meet [SNFR2]({{% siteparam base %}}/spec/SNFR2), ensure the updated module is deployable against a testing Azure subscription and compliant with the intended configuration.

Depending on the type of contribution (for example, a new resource module feature), update the end-to-end tests. A new parameter may require adding its usage to an existing test or adding a new test, as described in [BCPRMNFR1]({{% siteparam base %}}/spec/BCPRMNFR1).

Run the applicable local checks before opening the PR. See the [local validation guide]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally/) for `avm test unit`, `avm pr-check`, and optional local E2E commands. Local checks do not replace PR checks.

{{% notice style="tip" %}}

Use an authorized test subscription for local E2E tests; the command can create, update and remove Azure resources.

{{% /notice %}}

### Creating end-to-end tests

As per [BCPRMNFR1]({{% siteparam base %}}/spec/BCPRMNFR1), a resource module must contain a minimum set of deployment test cases, while for pattern modules there is no restriction on the naming each deployment test must have.
In either case, you're free to implement any additional, meaningful test that you see fit. Each test is implemented in its own test folder, containing at least a `main.test.bicep` and optionally any amount of extra deployment files that you may require (e.g., to deploy dependencies using a `dependencies.bicep` that you reference in the test template file).

To get started implementing your test in the `main.test.bicep` file, we recommend the following guidelines:

- As per [BCPNFR13]({{% siteparam base %}}/spec/BCPNFR13), each `main.test.bicep` file should implement metadata to render the test more meaningful in the documentation
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

  {{% notice style="important" %}}

  As per [BCPNFR12]({{% siteparam base %}}/spec/BCPNFR12) you must use the header `module testDeployment '../.*main.bicep' =` when invoking the module's template.

  {{% /notice %}}

  {{% notice style="tip" %}}

  📜 [Example of test file](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/storage/storage-account/tests/e2e/defaults/main.test.bicep)

  {{% /notice %}}

Dependency file (`dependencies.bicep`) guidelines:

- The `dependencies.bicep` should optionally be used if any additional dependencies must be deployed into a nested scope (e.g. into a deployed Resource Group).
- Note that you can reuse many of the assets implemented in other modules. For example, there are many recurring implementations for Managed Identities, Key Vaults, Virtual Network deployments, etc.

- A special case to point out is the implementation of Key Vaults that require purge protection (for example, for Customer Managed Keys). As this implies that we cannot fully clean up a test deployment, it is recommended to generate a new name for this resource upon each pipeline run using the output of the `utcNow()` function at the time.

  {{% notice style="tip" %}}

  📜 [Example of test using purge protected Key Vault dependency](https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/cognitive-services/account/tests/e2e/cmk-sami/main.test.bicep#L43)

  {{% /notice %}}

  {{% notice style="tip" %}}

  📜 If your test case requires environment-specific inputs (e.g., tenant-specific object IDs or secrets), use [Custom CI parameters]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/custom-ci-secrets) to supply them from GitHub Actions secrets or variables. The CI passes matching values as deployment parameters; it does not substitute them into the test source.

  {{% /notice %}}

### Reusable assets

The [e2e template assets](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/e2e-template-assets) provide additional scripts and utilities that may be of use to module owners/contributors. These contain both scripts and Bicep templates that you can re-use in your test files (e.g., to deploy standadized dependencies, or to generate keys using deployment scripts).

<u><b>Example:</b> Certificate creation script</u>

If you need a Deployment Script to set additional non-template resources up (for example certificates/files, etc.), we recommend to store it as a file in the shared `utilities/e2e-template-assets/scripts` folder and load it using the template function `loadTextContent()` (for example: `scriptContent: loadTextContent('../../../../../../utilities/e2e-template-assets/scripts/New-SSHKey.ps1')`). This approach makes it easier to test & validate the logic and further allows reusing the same logic across multiple test cases.

<u><b>Example:</b> Diagnostic Settings dependencies</u>

To test the numerous diagnostic settings targets (Log Analytics Workspace, Storage Account, Event Hub, etc.) the AVM core team have provided a dependencies `.bicep` file to help create all these pre-requisite targets that will be needed during test runs.

{{% expand title="➕ Diagnostic Settings Dependencies - Bicep File" %}}

{{< highlight lineNos="false" type="bicep" wrap="true" title="" >}}

{{% include file="/static/includes/diagnostic.dependencies.bicep" %}}

{{< /highlight >}}

{{% /expand %}}

## 6. Raise or update PR

Finally, once you are satisfied with your contribution and validated it, open a pull request for review. Make sure you:

1. Provide a meaningful title in the form of _feat: `<module name>`_ to align with the Semantic PR Check.
2. Provide a meaningful description.
3. Follow instructions you find in the PR template.
{{< tabs groupid="persona" >}}

{{% tab title="Microsoft FTE" %}}

Create a PR from your branch to `main` in the upstream `Azure/bicep-registry-modules` repository.

{{% /tab %}}

{{% tab title="External contributor" %}}

Create a PR from your fork's branch to `main` in the upstream `Azure/bicep-registry-modules` repository.

{{% /tab %}}

{{< /tabs >}}

Shared PR checks run when the PR is opened, reopened or updated. The `PR: Run E2E Tests` label requests deployment tests for a same-repository PR. An external fork PR cannot run deployment tests through this label; use the release-branch handoff only when E2E testing is needed. See [CI guidance](#7-approve-and-monitor-ci-tests).

{{% notice style="note" %}}

If you receive any comments for your pull request, please adhere to the following practices
- If it is a 'suggestion' that you agree with, you can directly commit it into your branch by selecting the 'Apply suggestion' button, auto-resolving the comment
- If it's a regular comment that you agree with, please address its ask and leave a comment indicating the same. Do **not** resolve it yourself as this renders a re-review a lot harder for the reviewer.

{{% /notice %}}

## 7. Approve and monitor CI tests

The shared PR check runs validation and applicable unit tests on the PR. Review the job results on the PR and address failures on the same branch.

### Running E2E for your own contributions

Microsoft FTEs run deployment tests from their upstream PR by adding the `PR: Run E2E Tests` label. The label starts a check run and enables deployment tests on subsequent updates.

### Running E2E for external contributions

External fork PRs do not run credentialed E2E tests through the label. If E2E testing is needed, an FTE must first review the source code and workflow changes for security, then run the shared `Avm.Authoring` command using the GitHub CLI (`gh`). Ensure `gh` is authenticated as an authorized FTE with access to the upstream repository. The command is implemented but not yet released; once available, run it with the fork PR's reviewed head commit:

```powershell
$reviewedSha = '<full reviewed PR head commit SHA>'
avm release-branch `
  --repository Azure/bicep-registry-modules `
  --pull-request 123 `
  --reviewed-head-commit $reviewedSha
```

The `--reviewed-head-commit` value pins the handoff to the exact PR revision reviewed. The command creates a release branch from `main`, retargets and merges the fork PR into that branch, then opens a follow-up PR from the release branch to `main`. It labels the Bicep follow-up PR with `PR: Run E2E Tests`. The FTE's invocation runs the handoff; no separate confirmation prompt is required. Use `--whatif` to preview without making changes. The command stops rather than bypassing repository protections.

If tests fail, ask the contributor to update the original PR and repeat the handoff with the new changes.

## 8. Review and merge PR

To publish a new module or a new version of an existing module, each Pull Request (PR) **MUST** be reviewed and approved before being merged and published in the Public Bicep Registry. **A contributor (the submitter of the PR) cannot approve their own PR.**

The [reviewer-routing workflow](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-pr-reviewer-routing.yml) requests module owners from root `metadata.json` and applies triage labels when active. Reviewer requests do not set approval requirements.

{{% notice style="important" %}}

As part of the PR review process, the submitter (contributor) **MUST** address any comments raised by the reviewers and request a new review - and repeat this process until the PR is approved.
Once the PR is merged, the module owner **MUST** verify that the [release workflow](#9-module-release) and subsequent registry publication completed successfully.

{{% /notice %}}

### 8.1. Publishing a new module

When publishing a net new module for the first time ever, the PR **MUST** be reviewed and approved by a member of the core team.

### 8.2. Publishing a new version of an existing module

For ordinary code changes in an existing Bicep module, any eligible BRM repository team member may approve and merge under repository rules; a module owner's approval is not mandatory. If you are the sole owner and author, request another eligible reviewer. Changes to `metadata.json` still require [metadata code-owner review]({{% siteparam base %}}/contributing/module-metadata/#submit-and-review-a-change). Other protected paths follow their [applicable `CODEOWNERS` rules]({{% siteparam base %}}/spec/SNFR20#codeowners-file).

## 9. Module release

The shared [module release workflow](https://github.com/Azure/bicep-registry-modules/blob/main/.github/workflows/release.yml) is designed to run on pushes to `main` and can also be started manually. It discovers pending module releases, requires the relevant changelog entry, and requests approval through the `publish-approval` environment before creating scoped release tags. The tags identify the exact source revision; the separate registry publishing process consumes them. A successful tag-creation job alone does not prove that the version is available in the public registry.

The `main` push trigger must be enabled for automatic releases; until then, the workflow is manual only.

<!--
## Publishing to the Registry

When the AVM Modules are published to the Bicep Public Registry they **MUST** follow the below requirements:

- Resource Module: `avm/res/<rp>/<resource type>` as per [RMNFR1]({{% siteparam base %}}/specRMNFR1)
- Pattern Module: `avm/ptn/<patternmodulename>` as per [PMNFR1]({{% siteparam base %}}/spec/PMNFR1)

This will require the alias on the MCR to be different than the directory path, which is the default for BRM today.

***Guidance will be provided below on how to do this, when available.***
-->
