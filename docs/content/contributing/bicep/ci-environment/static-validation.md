---
title: CI environment - Static validation
---

This section provides an overview of the principles the static validation is built upon, how it is set up, and how you can interact with it.

![Static Validation Step]({{% siteparam base %}}/img/bicep-ci/static-validation-step.png?width=400px)

## Static code validation

All module Unit tests are performed with the help of [Pester](https://github.com/pester/Pester) to ensure that the modules are configured correctly, documentation is up to date and modules don't turn stale.

### Outline

The following activities are performed by the [`utilities/pipelines/staticValidation/compliance/module.tests.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/staticValidation/compliance/module.tests.ps1) script.

- **File/folder tests**
  - **General module folder tests**
    1. Module should contain a [` main.bicep `] file.
    1. Module should contain a [` main.json `] file.
    1. Module should contain a [` README.md `] file.
    1. Module should contain a [` CHANGELOG.md `] file.
    1. Main module version should be increased in the [` version.json `] file, if the child version number has been increased.
    1. Module should contain a [` ORPHANED.md `] file only, if the module is orphaned.
    1. Module should contain a [` version.json `] file.
    1. Module should contain a [` tests `] folder.
    1. Module should contain a [` tests/e2e `] folder.
    1. Module should contain a [` tests/e2e/waf-aligned `] folder.
    1. Module should contain a [` tests/e2e/defaults `] folder.
    1. Module should contain a [` main.test.bicep `] file in each e2e test folder.
- **Pipeline tests**
    1. Module should have a GitHub workflow [` .github/workflows/<workflowFileName> `].
    1. Module workflow should have [` workflowPath `] environment variable with the value [` .github/workflows/<workflowFileName> `].
- **Module tests**
  - **Readme content tests**
    1. `Set-ModuleReadMe` script should not apply any updates.
  - **Compiled ARM template tests**
    1. Compiled ARM template should be based on the current Bicep template.
  - **General template tests**
    1. The template file should not be empty.
    1. Template schema version should be the latest.
    1. Template schema should use HTTPS reference.
    1. The template file should contain required elements [schema], [contentVersion], [resources].
    1. The template file should have a module name specified.
    1. The template file should have a module description specified.
  - **Parameters template tests**
    1. The Location should be defined as a parameter, with the default value of 'resourceGroup().location' or global' for ResourceGroup deployment scope.
    1. The telemetry parameter should be present and valid.
    1. Parameter & UDT names should be camel-cased (no dashes or underscores and must start with lower-case letter).
    1. Each parameters' & UDT's description should be well formatted.
    1. Conditional parameters' & UDT's description should contain 'Required if' followed by a definition.
    1. Non-required parameters' and UDT's description should not start with 'Required'.
    1. Required parameters' and UDT's description should start with 'Required|Conditional'.
    - **UDT Parameters template tests**
      1. Parameters should implement AVM's corresponding user-defined type.
      1. If a UDT definition [managedIdentitiesType] exists and the module supports system-assigned-identities, an output for its principal ID should exist.
      1. A parameter [tags] should be 'nullable'.
  - **Variables template tests**
    1. Variable names should be camel-cased (no dashes or underscores and must start with lower-case letter).
  - **Resources template tests**
    1. Telemetry deployment should be present in the template.
    1. Telemetry deployment should have correct condition in the template.
    1. Telemetry deployment should have expected inner output for verbosity.
    1. Telemetry deployment should have expected telemetry identifier.
  - **Output template tests**
    1. Output names should be camel-cased (no dashes or underscores and must start with lower-case letter).
    1. Output names description should be well formatted.
    1. Location output should be returned for resources that use it.
    1. Resource Group output should exist for resources that are deployed into a resource group scope.
    1. Resource name output should exist.
    1. Resource ID output should exist.
    1. Resource modules Principal ID output should exist, if supported.
  - [**Changelog content tests**]({{% siteparam base %}}/contributing/bicep/ci-environment/changelog-automation)
    1. The changelog should not be empty.
    1. The changelog shoud start with '# Changelog'.
    1. The changelog shoud start with '# Changelog', followed by an empty line.
    1. The '## unreleased' section should be in the changelog.
    1. The '## unreleased' section should be in the changelog only once.
    1. The '## unreleased' section should be the first section in the changelog.
    1. The versions in the changelog should appear in descending order.
    1. The '## unreleased' section should contain "New Features" surrounded by empty lines.
    1. The '## unreleased' section should contain "Changes" surrounded by empty lines.
    1. The '## unreleased' section should contain "Bugfixes" surrounded by empty lines.
    1. The '## unreleased' section should contain "Breaking Changes" surrounded by empty lines.
    1. The '## unreleased' section should contain actual content and not just headers or empty lines.
- **Governance tests**
  1. Owning team should be specified correctly in CODEWONERS file.
  1. Module identifier should be listed in issue template in the correct alphabetical position.
- **Test file tests**
  - **General test file**
    1. Bicep test deployment should have parameter [serviceShort].
    1. Bicep test deployment files in a [defaults] folder should have a parameter [serviceShort] with a value ending with 'min'.
    1. Bicep test deployment files in a [max] folder should have a parameter [serviceShort] with a value ending with 'max'.
    1. Bicep test deployment files in a [waf-aligned] folder should have a parameter [serviceShort] with a value ending with 'waf'.
    1. Bicep test deployment files should contain a metadata string [name].
    1. Bicep test deployment files should contain a metadata string [description] .
    1. Bicep test deployment files should contain a parameter [namePrefix] with value '#_namePrefix_#'.
    1. Bicep test deployment files should invoke test like [`module testDeployment '../.*main.bicep' = [ or {`] .
    1. Bicep test deployment name should contain [`-test-`].
- **API version tests**
    1. In used resource type should use one of the recent API version(s).

### Output example

Every test creates output, that is written to the workflows log. *Yellow* lines are either verbose or warning messages, whereas *red* lines are actuall errors, which mark the whole test as faulty and stopps the CI pipeline.

![Static Validation Output]({{% siteparam base %}}/img/bicep-ci/static-validation-output.png?width=400px)

## API version validation

In this phase, Pester analyzes the API version of each resource type deployed by the module.

In particular, each resource's API version is compared with those currently available on Azure. This test has a certain level of tolerance (does not enforce the latest version): the API version in use should be one of the 5 latest versions available (including preview versions) or one of the the 5 latest non-preview versions.

This test also leverages the [`utilities/pipelines/staticValidation/compliance/module.tests.ps1`](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/staticValidation/compliance/module.tests.ps1) script.

To test the API versions, the test leverages the file `governance/apiSpecsList.json` file as a reference for all API versions available for any used Provider Namespace & Resource Type.

> **NOTE:** If this file does not exist, the API tests will be skipped.

> **NOTE:** This functionality has a dependency on the [AzureAPICrawler](https://www.powershellgallery.com/packages/AzureAPICrawler) PowerShell module.

The [Set-ModuleReadMe.ps1](https://github.com/Azure/bicep-registry-modules/blob/main/utilities/pipelines/sharedScripts/Set-ModuleReadMe.ps1) will read the file and check the referenced APIs in the module against that list.

## Verify the static validation of your module locally

This paragraph is intended for AVM contributors or more generally for those leveraging the AVM CI environment and having the need to update or add a new module to the library.

Refer to the below snippet to leverage the 'Test-ModuleLocally.ps1' script and verify if your module will comply to the static validation before pushing to source control.

```powershell
#########[ Function Test-ModulesLocally.ps1 ]#############
$pathToRepository = '<pathToClonedRepo>'
. "$pathToRepository\utilities\tools\Test-ModuleLocally.ps1"

# REQUIRED INPUT FOR TESTING
$TestModuleLocallyInput = @{
    templateFilePath              = "$pathToRepository\modules\authorization\role-definition\main.bicep"
    PesterTest                    = $true
    PesterTestRecurse             = $true
    ValidationTest                = $false
    DeploymentTest                = $false
    ValidateOrDeployParameters = @{
      Location         = 'germanywestcentral'
      SubscriptionId   = '00000000-0000-0000-0000-000000000000'
      RemoveDeployment = $true
    }
    AdditionalTokens           = @{
      namePrefix = 'abcd'
      TenantId   = '00000000-0000-0000-0000-000000000000'
    }
}

Test-ModuleLocally @TestModuleLocallyInput -Verbose
```

> You can use the `Get-Help` cmdlet to show more options on how you can use this script.
