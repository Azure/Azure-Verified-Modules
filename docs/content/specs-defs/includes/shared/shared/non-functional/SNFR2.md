---
title: SNFR2 - E2E Testing
url: /spec/SNFR2
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
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

#### ID: SNFR2 - Category: Testing - E2E Testing

Modules **MUST** implement end-to-end (deployment) testing that create actual resources to validate that module deployments work. In Bicep tests are sourced from the directories in `/tests/e2e`. In Terraform, these are in `/examples`.

Each test **MUST** run and complete without user inputs successfully, for automation purposes.

Each test **MUST** also destroy/clean-up its resources and test dependencies following a run.

{{< hint type=tip >}}

To see a directory and file structure for a module, see the language specific contribution guide.

- [Bicep](/Azure-Verified-Modules/contributing/bicep#directory-and-file-structure)
- [Terraform](/Azure-Verified-Modules/contributing/terraform#directory-and-file-structure)

{{< /hint >}}

##### Required Resources/Dependencies Required for E2E Tests

It is likely that to complete E2E tests, a number of resources will be required as dependencies to enable the tests to pass successfully. Some examples:

- When testing the Diagnostic Settings interface for a Resource Module, you will need an existing Log Analytics Workspace to be able to send the logs to as a destination.
- When testing the Private Endpoints interface for a Resource Module, you will need an existing Virtual Network, Subnet and Private DNS Zone to be able to complete the Private Endpoint deployment and configuration.

Module owners **MUST**:

- Create the required resources that their module depends upon in the test file/directory
  - They **MUST** either use:
    - Simple/native resource declarations/definitions in their respective IaC language, <br> **OR**
    - Another already published AVM Module that **MUST** be pinned to a specific published version.
      - They **MUST NOT** use any local directory path references or local copies of AVM modules in their own modules test directory.

{{< expand "➕ Terraform & Bicep Log Analytics Workspace examples using simple/native declarations for use in E2E tests" "expand/collapse">}}

###### Terraform

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

###### Bicep

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

{{< /expand >}}
