This section describes the contribution flow for module owners who are responsible for creating and maintaining Terraform Module repositories.

- [1. GitHub repository creation and configuration](#1-github-repository-creation-and-configuration)
- [2. GitHub Respotory Labels](#2-github-respotory-labels)
- [3. Setup Azure environment for AVM e2e tests](#3-setup-azure-environment-for-avm-e2e-tests)
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
<!-- TODO:
- Add the creation of 1ES pool
-->

### 1. GitHub repository creation and configuration

Familiarise yourself with the AVM Resource Module Naming in the [module index csv's](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes).

- Example: `terraform-<provider>-avm-res-<rp>-<ARM resource type>`

1. Create GitHub teams:

- `@Azure/avm-res-<RP>-<modulename>-module-owners-tf`
- `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf`

2. Create the module repostory using [terraform-azuremrm-avm-template](https://github.com/Azure/terraform-azurerm-avm-template) in the `Azure` organisation with the following [details (internal only)](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review). You will then have to complete the configuration of your repository and start an [internal business review](https://dev.azure.com/CSUSolEng/Azure%20Verified%20Modules/_wiki/wikis/AVM%20Internal%20Wiki/333/-TF-Create-repository-in-Github-Azure-org-and-conduct-business-review?anchor=conduct-initial-repo-configuration-and-trigger-business-review).

3. Add these teams with the following permissions to the repository:

- Admin: `@Azure/avm-core-team` = AVM Core Team
- Admin: `@Azure/terraform-azure` = Terraform PG
- Admin: `@Azure/avm-res-<RP>-<modulename>-module-owners-tf` = AVM Resource Module Owners
- Write: `@Azure/avm-res-<RP>-<modulename>-module-contributors-tf` = AVM Resource Module Contributors

4. Set up a GitHub repository Environment called `test`.

5. Create the following environment secrets on the `test` environment

<!-- TODO: secrets can be removed since the latest azteraform docker image with having ./avm implemented -->

- `AZURE_CLIENT_ID` # Object (principal) ID of the UAMI
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`

A client secret is not required as the UAMI is used for authentication.

6. Create deployment protection rules for the `test` environment to avoid spinning up e2e tests with every pull request raised by third-parties. Add the following teams as required reviewers:

- AVM Core Team: `@Azure/avm-core-team`
- Terraform PG: `@Azure/terraform-azure`
- AVM Resource Module Owners: `@Azure/avm-res-<RP>-<modulename>-module-owners-tf`

<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionTeams.png" alt="Required reviewers." width=100%>

<p>

<!--
<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionRules.png" alt="Deployment prpotection rules." width=100%>
-->
<img src="/Azure-Verified-Modules/img/contribution/deploymentProtectionRules2.png" alt="Deployment prpotection rules." width=100%>

<br>

---

<br>

### 2. GitHub Respotory Labels

As per [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels) the repositories created by module owners **MUST** have and use the pre-defined GitHub labels. To apply these labels to the repository review the PowerShell script `Set-AvmGitHubLabels.ps1` that is provided in [SNFR23](/Azure-Verified-Modules/specs/shared/#id-snfr23---category-contributionsupport---github-repo-labels).

```pwsh
Set-AvmGitHubLabels.ps1 -RepositoryName "Azure/MyGitHubRepo" -CreateCsvLabelExports $false -NoUserPrompts $true
```

<br>

---

<br>

### 3. Setup Azure environment for AVM e2e tests

A module owner can own multiple modules and therefore we recommend to create distinguished User Assigned Managed Identities (UAMI) for each repository a module owner owns. This makes it easier to identify the deployments performed by each identity in the Azure Portal. The UAMI name should follow the pattern `terraform-<provider>-avm-res-<resource provider>-<modulename>`:

1. Create an UAMI in your Azure test subscription.
2. Create a role assignment for the UAMI on your test subscription, use `Contributor` role (your module might require higher privileges) such as `Owner` but we reocmmend to go with least privilege.

3. Configure [federated identity credentials](https://learn.microsoft.com/en-us/entra/workload-id/workload-identity-federation-create-trust-user-assigned-managed-identity?pivots=identity-wif-mi-methods-azcli) on the user assigned managed identity. Use the GitHub `test` environment.

You can use the following script to create the UAMI, role assignment and federated identity credentials:

```pwsh
# Create UAMI
$identityName = "terraform-<provider>-avm-res-<resource provider>-<modulename>" # e.g. terraform-azurerm-avm-res-keyvault-vault
$resourceGroupName = "<resource group name>"
$roleName = "Contributor"
$subscriptionID = $(az account show --query id --output tsv)
echo "Creating UAMI $identityName, with role $roleName assigned to /subscriptions/$subscriptionID"

$identity=az identity create -g $resourceGroupName -n $identityName
$principalId=$(az identity show -n $identityName -g $resourceGroupName --query principalId --out tsv)
az role assignment create --assignee $principalId --role $roleName --scope /subscriptions/$subscriptionID

# Create federated identity credentials
$fcName = $identityName
az identity federated-credential create --name $fcName --identity-name $identityName --resource-group $resourceGroupName --issuer "https://token.actions.githubusercontent.com" --subject "repo:Azure/$($identityName):environment:test" --audiences 'api://AzureADTokenExchange'
```

<br>

---

<br>

### 4. Publish the module

Once the module is ready to be published, follow the below steps to publish the module to the HashiCorp Registry.

Ensure your module is ready for publishing:

1. All tests are passing.
2. All examples are passing.
3. All documentation is generated.
4. Include/Add [`@Azure/avm-core-team-technical`](https://github.com/orgs/Azure/teams/avm-core-team-technical/members) as a reviewer (if not added automatically added already).
5. The repository has an existing tag with the version number you want to publish.
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
