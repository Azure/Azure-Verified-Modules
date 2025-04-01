---
title: SNFR2 - E2E Testing
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/SNFR2
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Testing, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1030
---

## ID: SNFR2 - Category: Testing - E2E Testing

Modules **MUST** implement end-to-end (deployment) testing that create actual resources to validate that module deployments work. In Bicep tests are sourced from the directories in `/tests/e2e`. In Terraform, these are in `/examples`.

Each test **MUST** run and complete without user inputs successfully, for automation purposes.

Each test **MUST** also destroy/clean-up its resources and test dependencies following a run.

{{% notice style="tip" %}}

To see a directory and file structure for a module, see the language specific contribution guide.

- [Bicep]({{% siteparam base %}}/contributing/bicep#directory-and-file-structure)
- [Terraform]({{% siteparam base %}}/contributing/terraform#directory-and-file-structure)

{{% /notice %}}

### Resources/Dependencies Required for E2E Tests

It is likely that to complete E2E tests, a number of resources will be required as dependencies to enable the tests to pass successfully. Some examples:

- When testing the Diagnostic Settings interface for a Resource Module, you will need an existing Log Analytics Workspace to be able to send the logs to as a destination.
- When testing the Private Endpoints interface for a Resource Module, you will need an existing Virtual Network, Subnet and Private DNS Zone to be able to complete the Private Endpoint deployment and configuration.

Module owners **MUST**:

- Create the required resources that their module depends upon in the test file/directory
  - They **MUST** either use:
    - Simple/native resource declarations/definitions in their respective IaC language, <br> **OR**
    - Another already published AVM Module that **MUST** be pinned to a specific published version.
      - They **MUST NOT** use any local directory path references or local copies of AVM modules in their own modules test directory.

{{% expand title="➕ Terraform & Bicep Log Analytics Workspace examples using simple/native declarations for use in E2E tests" expanded="false" %}}

#### Terraform

```terraform
resource "azurerm_resource_group" "example" {
  name     = "rsg-test-001"
  location = "West Europe"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "law-test-001"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
```

#### Bicep

```bicep
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'law-test-001'
  location: resourceGroup().location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}
```

{{% /expand %}}

##### Skipping Deployments (**SHOULD NOT**)

Deployment tests are an important part of a module's validation and a staple of AVM's CI environment. However, there are situations where certain e2e-test-deployments cannot be performed against AVM's test environment (e.g., if a special configuration/registration (such as certain AI models) is required). For these cases, the CI offers the possibility to 'skip' specific test cases by placing a file named `.e2eignore` in their test folder.

{{% notice style="note" %}}
A skipped test case is still added to the 'Usage Examples' section of the module's readme and should be manually validated in regular intervals.
{{% /notice %}}

{{% tabs title="Details for use in E2E tests" groupid="e2eignore" %}}
  {{% tab title="Bicep" %}}

You **MUST** add a note to the tests metadata description, which explains the excemption.

If you require that a test is skipped and add an “.e2eignore” file (e.g. `\<module\>/tests/e2e/\<testname\>/.e2eignore`) to a pull request, a member of the AVM Core Technical Bicep Team must approve set pull request. The content of the file is logged the module's workflow runs and transparently communicates why the test case is skipped during the deployment validation stage. It iss hence important to specify the reason for skipping the deployment in this file.

Sample filecontent:

```text
The test is skipped, as only one instance of this service can be deployed to a subscription.
```

{{% notice style="note" %}}
For resource modules, the 'defaults' and 'waf-aligned' tests can't be skipped.
{{% /notice %}}

  {{% /tab %}}
  {{% tab title="Terraform" %}}

The deployment of a test can be skipped by adding a `.e2eignore` file into a test folder (e.g. /examples/\<testname\>).

  {{% /tab %}}
{{% /tabs %}}
