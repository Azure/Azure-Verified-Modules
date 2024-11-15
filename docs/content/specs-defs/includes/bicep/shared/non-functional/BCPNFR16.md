---
title: BCPNFR16 - Post-deployment tests
url: /spec/BCPNFR16
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Testing,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 11150
---

#### ID: BCPNFR16 - Category: Testing - Post-deployment tests

For each test case in the `e2e` folder, you can optionally add post-deployment Pester tests that are executed once the corresponding deployment completed and before the removal logic kicks in.

To leverage the feature you **MUST**:

- Use Pester as a test framework in each test file
- Name the file with the suffix `"*.tests.ps1"`
- Place each test file the `e2e` test's folder or any subfolder (e.g., `e2e/max/myTest.tests.ps1` or `e2e/max/tests/myTest.tests.ps1`)
- Implement an input parameter `TestInputData` in the following way:

  ```pwsh
  param (
      [Parameter(Mandatory = $false)]
      [hashtable] $TestInputData = @{}
  )
  ```

  Through this parameter you can make use of every output the `main.test.bicep` file returns, as well as the path to the test template file in case you want to extract data from it directly.

  For example, with an output such as `output resourceId string = testDeployment[1].outputs.resourceId` defined in the `main.test.bicep` file, the `$TestInputData` would look like:

  ```pwsh
  $TestInputData = @{
    DeploymentOutputs    = @{
      resourceId = @{
        Type  = "String"
        Value = "/subscriptions/***/resourceGroups/dep-***-keyvault.vaults-kvvpe-rg/providers/Microsoft.KeyVault/vaults/***kvvpe001"
      }
    }
    ModuleTestFolderPath = "/home/runner/work/bicep-registry-modules/bicep-registry-modules/avm/res/key-vault/vault/tests/e2e/private-endpoint"
  }
  ```

  A full test file may look like:

  {{< expand "➕ Pester post-deployment test file example" "expand/collapse">}}

  ```pwsh
  param (
      [Parameter(Mandatory = $false)]
      [hashtable] $TestInputData = @{}
  )

  Describe 'Validate private endpoint deployment' {

      Context 'Validate sucessful deployment' {

          It "Private endpoints should be deployed in resource group" {

              $keyVaultResourceId = $TestInputData.DeploymentOutputs.resourceId.Value
              $testResourceGroup = ($keyVaultResourceId -split '\/')[4]
              $deployedPrivateEndpoints = Get-AzPrivateEndpoint -ResourceGroupName $testResourceGroup
              $deployedPrivateEndpoints.Count | Should -BeGreaterThan 0
          }
      }
  }
  ```

  {{< /expand >}}
