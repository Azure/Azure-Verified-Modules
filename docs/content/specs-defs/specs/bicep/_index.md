---
title: Bicep Specific Specification
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/bicep/
---

{{< hint type=tip >}}

Make sure to checkout the [Shared Specification](/Azure-Verified-Modules/specs/shared/) first before reading further so you understand the specifications items that are shared and agnostic to the IaC language/tool.

{{< /hint >}}

{{< hint type=important >}}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED”, “MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119).

{{< /hint >}}

<br>

This page contains the **Bicep specific requirements** for AVM modules (**Resource and Pattern modules**) that ALL Bicep AVM modules **MUST** meet. These requirements are in addition to the [Shared Specification](/Azure-Verified-Modules/specs/shared/) requirements that ALL AVM modules **MUST** meet.

The following table summarizes the category identification codes used in this specification:

| Scope                                            | Functional requirements                 | Non-functional requirements                   |
|--------------------------------------------------|-----------------------------------------|-----------------------------------------------|
| Shared requirements (resource & pattern modules) | [BCPFR](#functional-requirements-bcpfr) | [BCPNFR](#non-functional-requirements-bcpnfr) |
| Resource module level requirements               | *N/A*                                   | [BCPRMNFR](#non-functional-requirements-bcprmnfr)                                      |
| Pattern module level requirements                | *N/A*                                   | *N/A*                                         |

<br>

{{< toc >}}

<br>

## Shared Requirements (Resource & Pattern Modules)

Listed below are both functional and non-functional requirements for Bicep AVM modules (Resource and Pattern).

<br>

### Functional Requirements (BCPFR)

{{< hint type=note >}}
This section includes **Bicep specific, functional requirements (BCPFR)** for AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: BCPFR1 - Category: Composition - Cross-Referencing Modules

Module owners **MAY** cross-references other modules to build either Resource or Pattern modules.

However, they **MUST** be referenced only by a public registry reference to a pinned version e.g. `br/public:avm/xxx/yyy:1.2.3`. They **MUST NOT** use local parent path references to a module e.g. `../../xxx/yyy.bicep`.

Although, child modules, that are children of the primary resources being deployed by the AVM Resource Module, **MAY** be specified via local child path e.g. `child/resource.bicep`.

Modules **MUST NOT** contain references to non-AVM modules.

<br>

---

<br>

#### ID: BCPFR2 - Category: Composition - Role Assignments Role Definition Mapping

Module owners **MAY** define common RBAC Role Definition names and IDs within a variable to allow consumers to define a RBAC Role Definition by their name rather than their ID, this should be self contained within the module themselves.

However, the **MUST** use only the official RBAC Role Definition name within the variable and nothing else.

To meet the requirements of [BCPFR2](/Azure-Verified-Modules/specs/bicep/#id-bcpfr2---category-composition---role-assignments-role-definition-mapping), [BCPNFR5](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr5---category-composition---role-assignments-role-definition-mapping-limits) and [BCPNFR6](/Azure-Verified-Modules/specs/bicep/#id-bcpnfr6---category-composition---role-assignments-role-definition-mapping-compulsory-roles) you **MUST** use the below code sample in your AVM Modules to achieve this.

{{< include file="/static/includes/sample.rbacMapping.bicep" language="bicep" options="linenos=false" >}}

<br>

---

<br>

#### ID: BCPFR4 - Category: Composition - Telemetry Enablement

To comply with specifications outlined in [SFR3](/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry) & [SFR4](/Azure-Verified-Modules/specs/shared/#id-sfr4---category-telemetry---telemetry-enablement-flexibility) you **MUST** incorporate the following code snippet into your modules. Place this code sample in the "top level" `main.bicep` file; it is not necessary to include it in any nested Bicep files (child modules).

{{< include file="/static/includes/sample.telem.bicep" language="bicep" options="linenos=false" >}}

<br>

---

<br>

#### ID: BCPFR5 - Category: Inputs - Availability Zones Implementation

To implement requirement [SFR5](/Azure-Verified-Modules/specs/shared/#id-sfr5---category-composition---availability-zones), the following convention should apply:

{{< tabs "zones" >}}
  {{< tab "Module accepts multiple zones" >}}
  In this case, the parameter should be implemented like

  ```bicep
  @description('Optional. The Availability Zones to place the resources in.')
  @allowed([
    1
    2
    3
  ])
  param zones int[] = [
    1
    2
    3
  ]

  resource myResource (...) {
    (...)
    properties: {
      (...)
      zones: map(zones, zone => string(zone))
    }
  }
  ```
  {{< /tab >}}
  {{< tab "Module accepts a single zone" >}}
  In this case, the parameter should be implemented using a singular-named `zone` parameter of type `int` like

  ```bicep
  @description('Required. The Availability Zone to place the resource in. If set to 0, then Availability Zone is not set.')
  @allowed([
    0
    1
    2
    3
  ])
  param zone int

  resource myResource (...) {
    (...)
    properties: {
      (...)
      zones: zone != 0 ? [ string(zone) ] : null
    }
  }
  ```
  {{< /tab >}}
{{< /tabs >}}

<br>

---

<br>


### Non-Functional Requirements (BCPNFR)

{{< hint type=note >}}
This section includes **Bicep specific, non-functional requirements (BCPNFR)** for AVM modules (Resource and Pattern).
{{< /hint >}}

---

<br>

#### ID: BCPNFR1 - Category: Inputs - Data Types

To simplify the consumption experience for module consumers when interacting with complex data types input parameters, mainly objects and arrays, the Bicep feature of [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) **MUST** be used and declared.

{{< hint type=tip >}}

User-Defined Types are GA in Bicep as of version v0.21.1, please ensure you have this version installed as a minimum.

{{< /hint >}}

[User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) allow intellisense support in supported IDEs (e.g. Visual Studio Code) for complex input parameters using arrays and objects.

{{< hint type=important title="CARML Migration Exemption" >}}

While the [transition of CARML](/Azure-Verified-Modules/faq/#carml-evolution) modules into AVM is complete, retrofitting [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) for all modules will take a considerable amount of time.

Therefore, the addition of [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) is currently **NOT** mandated/enforced. However, past their initial release, all modules **MUST** implement [User-Defined Types](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-data-types) prior to the release of their next version.

{{< /hint >}}

<br>

---

<br>

#### ID: BCPNFR7 - Category: Inputs - Parameter Requirement Types

Modules will have lots of parameters that will differ in their requirement type (required, optional, etc.). To help consumers understand what each parameter's requirement type is, module owners **MUST** add the requirement type to the beginning of each parameter's description. Below are the requirement types with a definition and example for the description decorator:

| Parameter Requirement Type | Definition | Example Description Decorator |
| -------------------------- | ---------- | ----------------------------- |
| Required | The parameter value must be provided. The parameter does not have a default value and hence the module expects and requires an input. | `@description('Required. <PARAMETER DESCRIPTION HERE...>')` |
| Conditional | The parameter value can be optional or required based on a condition, mostly based on the value provided to other parameters. Should contain a sentence starting with 'Required if (...).' to explain the condition. | `@description('Conditional. <PARAMETER DESCRIPTION HERE...>')` |
| Optional | The parameter value is not mandatory. The module provides a default value for the parameter. | `@description('Optional. <PARAMETER DESCRIPTION HERE...>')` |
| Generated | The parameter value is generated within the module and should not be specified as input in most cases. A common example of this is the `utcNow()` function that is only supported as the input for a parameter value, and not inside a variable. | `@description('Generated. <PARAMETER DESCRIPTION HERE...>')` |

<br>

---

<br>

#### ID: BCPNFR2 - Category: Documentation - Module Documentation Generation

{{< hint type=note >}}

This script/tool is currently being developed by the AVM team and will be made available very soon.

{{< /hint >}}

Bicep modules documentation **MUST** be automatically generated via the provided script/tooling from the AVM team, providing the following headings:

- Title
- Description
- Navigation
- Resource Types
- Usage Examples
- Parameters
- Outputs
- Cross-referenced modules

<br>

---

<br>

#### ID: BCPNFR3 - Category: Documentation - Usage Example formats

Usage examples for Bicep modules **MUST** be provided in the following formats:

- Bicep file (orchestration module style) - `.bicep`
  ```bicep
  module <resourceName> 'br/public:avm/res/<publishedModuleName>:1.0.0' = {
    name: '${uniqueString(deployment().name, location)}-test-<uniqueIdentifier>'
    params: { (...) }
  }
  ```
- JSON / ARM Template Parameter Files - `.json`
  ```json
  {
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": { (...) }
  }
  ```
{{< hint type=note >}}

The above formats are currently automatically taken & generated from the `tests/e2e` tests. It is enough to run the `Set-ModuleReadMe` or `Set-AVMModule` functions (from the `utilities` folder) to update the usage examples in the readme(s).

{{< /hint >}}

{{< hint type=note >}}

Bicep Parameter Files (`.bicepparam`) are being reviewed and considered by the AVM team for the usability and features at this time and will likely be added in the future.

{{< /hint >}}

<br>

---

<br>

#### ID: BCPNFR4 - Category: Documentation - Parameter Input Examples

Bicep modules **MAY** provide parameter input examples for parameters using the `metadata.example` property via the `@metadata()` decorator.

Example:

```bicep
@metadata({
  example: 'uksouth'
})
@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@metadata({
  example: '''
  {
    keyName: 'myKey'
    keyVaultResourceId: '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/my-rg/providers/Microsoft.KeyVault/vaults/myvault'
    keyVersion: '6d143c1a0a6a453daffec4001e357de0'
    userAssignedIdentityResourceId '/subscriptions/11111111-1111-1111-1111-111111111111/resourceGroups/my-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myIdentity'
  }
  '''
})
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType
```

It is planned that these examples are automatically added to the module readme's parameter descriptions when running either the `Set-ModuleReadMe` or `Set-AVMModule` scripts (available in the utilities folder).

<br>

---

<br>

#### ID: BCPNFR5 - Category: Composition - Role Assignments Role Definition Mapping Limits

As per [BCPFR2](#id-bcpfr2---category-composition---role-assignments-role-definition-mapping), module owners **MAY** define common RBAC Role Definition names and IDs within a variable to allow consumers to define a RBAC Role Definition by their name rather than their ID.

Module owners **SHOULD NOT** map every RBAC Role Definition within this variable as it can cause the module to bloat in size and cause consumption issues later when stitched together with other modules due to the 4MB ARM Template size limit.

Therefore module owners **SHOULD** only map the most applicable and common RBAC Role Definition names for their module and **SHOULD NOT** exceed 15 RBAC Role Definitions in the variable.

{{< hint type=important >}}

Remember if the RBAC Role Definition name is not included in the variable this does not mean it cannot be declared, used and assigned to an identity via an RBAC Role Assignment as part of a module, as any RBAC Role Definition can be specified via its ID without being in the variable.

{{< /hint >}}

{{< hint type=tip >}}

Review the [Bicep Contribution Guide's 'RBAC Role Definition Name Mapping' section](/Azure-Verified-Modules/contributing/bicep/#rbac-role-definition-name-mapping) for a code sample to achieve this requirement.

{{< /hint >}}

<br>

---

<br>

#### ID: BCPNFR6 - Category: Composition - Role Assignments Role Definition Mapping Compulsory Roles

Module owners **MUST** include the following roles in the variable for RBAC Role Definition names:

- Owner - ID: `8e3af657-a8ff-443c-a75c-2fe8c4bcb635`
- Contributor - ID: `b24988ac-6180-42a0-ab88-20f7382dd24c`
- Reader - ID: `acdd72a7-3385-48ef-bd42-f606fba81ae7`
- User Access Administrator - ID: `18d7d88d-d35e-4fb5-a5c3-7773c20a72d9`
- Role Based Access Control Administrator (Preview) - ID: `f58310d9-a9f6-439a-9e8d-f62e7b41a168`

{{< hint type=tip >}}

Review the [Bicep Contribution Guide's 'RBAC Role Definition Name Mapping' section](/Azure-Verified-Modules/contributing/bicep/#rbac-role-definition-name-mapping) for a code sample to achieve this requirement.

{{< /hint >}}

<br>

---

<br>

#### ID: BCPNFR8 - Category: Composition - Code Styling - lower camelCasing

Module owners **SHOULD** use [lower camelCasing](https://wikipedia.org/wiki/Camel_case) for naming the following:

- Parameters
- Variables
- Outputs
- User Defined Types
- Resources (symbolic names)
- Modules (symbolic names)

For example: `camelCasingExample` (lowercase first word (entirely), with capital of first letter of all other words and rest of word in lowercase)

<br>

---

<br>

#### ID: BCPNFR14 - Category: Composition - Versioning

To meet [SNFR17](/Azure-Verified-Modules/specs/shared/#id-snfr17---category-release---semantic-versioning) and depending on the changes you make, you may need to bump the version in the `version.json` file.

{{< include file="/static/includes/sample.bicep.version.json" language="json" options="linenos=false" >}}

The `version` value is in the form of `MAJOR.MINOR`. The PATCH version will be incremented by the CI automatically when publishing the module to the Public Bicep Registry once the corresponding pull request is merged. Therefore, contributions that would only require an update of the patch version, can keep the `version.json` file intact.

For example, the `version` value should be:
- `0.1` for new modules, so that they can be released as `v0.1.0`.
- `1.0` once the module owner signs off the module is stable enough for it’s first Major release of `v1.0.0`.
- `0.x` for all feature updates between the first release `v0.1.0` and the first Major release of `v1.0.0`.

<br>

---

<br>

#### ID: BCPNFR10 - Category: Testing - Test Bicep File Naming

Module owners **MUST** name their test `.bicep` files in the `/tests/e2e/<defaults/waf-aligned/max/etc.>` directories: `main.test.bicep` as the test framework (CI) relies upon this name.

<br>

---

<br>

#### ID: BCPNFR11 - Category: Testing - Test Tooling

Module owners **MUST** use the below tooling for unit/linting/static/security analysis tests. These are also used in the AVM Compliance Tests.

- [PSRule for Azure](https://azure.github.io/PSRule.Rules.Azure/)
- [Pester](https://pester.dev/)
  - Some tests are provided as part of the AVM Compliance Tests, but you are free to also use Pester for your own tests.

<br>

---

<br>

#### ID: BCPNFR12 - Category: Testing - Deployment Test Naming

Module owners **MUST** invoke the module in their test using the syntax:

```bicep
module testDeployment '../../../main.bicep' =
```

Example 1: Working example with a single deployment

```bicep
module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}'
  params: {
    (...)
  }
}
```

Example 2: Working example using a deployment loop

```bicep
@batchSize(1)
module testDeployment '../../main.bicep' = [for iteration in [ 'init', 'idem' ]: {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, location)}-test-${serviceShort}-${iteration}'
  params: {
    (...)
  }
}]
```

The syntax is used by the ReadMe-generating utility to identify, pull & format usage examples.

<br>

---

<br>

#### ID: BCPNFR13 - Category: Testing - Test file metadata

By default, the ReadMe-generating utility will create usage examples headers based on each `e2e` folder's name.
Module owners **MAY** provide a custom name & description by specfying the metadata blocks `name` & `description` in their `main.test.bicep` test files.

For example:
```bicep
metadata name = 'Using Customer-Managed-Keys with System-Assigned identity'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.'
```
would lead to a header in the module's `readme.md` file along the lines of
```markdown
### Example 1: _Using Customer-Managed-Keys with System-Assigned identity_

This instance deploys the module using Customer-Managed-Keys using a System-Assigned Identity. This required the service to be deployed twice, once as a pre-requisite to create the System-Assigned Identity, and once to use it for accessing the Customer-Managed-Key secret.
```

<br>

---

<br>

#### ID: BCPNFR15 - Category: Contribution/Support - AVM Module Issue template file

As part of the "initial Pull Request" (that publishes the first version of the module), module owners **MUST** add an entry to the `AVM Module Issue template` file in the BRM repository ([here](https://github.com/Azure/bicep-registry-modules/blob/main/.github/ISSUE_TEMPLATE/avm_module_issue.yml)).

{{< hint type=note >}}
Through this approach, the AVM core team will allow raising a bug or feature request for a module, only after the module gets merged to the [BRM](https://aka.ms/BRM) repository.
{{< /hint >}}

The module name entry **MUST** be added to the dropdown list with id `module-name-dropdown` as an option, in alphabetical order.

{{< hint type=important >}}
Module owners **MUST** ensure that the module name is added in alphabetical order, to simplify selecting the right module name when raising an AVM module issue.

{{< /hint >}}

Example - `AVM Module Issue template` module name entry for the Bicep resource module of Azure Virtual Network (`avm/res/network/virtual-network`):

```yaml
- type: dropdown
  id: module-name-dropdown
  attributes:
    label: Module Name
    description: Which existing AVM module is this issue related to?
    options:
      ...
      - "avm/res/network/virtual-network"
      ...
```

<br>

---

<br>

#### ID: BCPNFR16 - Category: Testing - Post-deployment tests

For each test case in the `e2e` folder, you can optionally add post-deployment Pester tests that are executed once the corresponding deployment completed and before the removal logic kicks in.

To leverage the feature you must
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

  For example, with an output such as `output resourceId string = testDeployment[1].outputs.resourceId` defined in the `main.test.bicep` file, the `$TestInputData` would look like
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
  A full test file may look like

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
              $deployedPrivateEndpoints = Get-AzPrivateEndpoint -ResourceGroupName   $testResourceGroup
              $deployedPrivateEndpoints.Count | Should -BeGreaterThan 0
          }
      }
  }
  ```
  {{< /expand >}}

---

<br>

#### ID: BCPNFR17 - Category: Composition - Code Styling - Type casting

To improve the usability of primitive module properties declared as strings, you should declare them using a type which better represents them, and apply any required casting in the module on behalf of the user.

For reference, please refer to the following examples:

<h5>Boolean as String</h5>
{{< tabs "booleanString" >}}
  {{< tab "Before" >}}

  ```bicep
  @allowed([
    'false'
    'true'
  ])
  param myParameterValue string = 'false'

  resource myResource '(...)' = {
    (...)
    properties: {
      myParameter: myParameterValue
    }
  }
  ```

  {{< /tab >}}
  {{< tab "After" >}}

  ```bicep
  param myParameterValue string = false

  resource myResource '(...)' = {
    (...)
    properties: {
      myParameter: string(myParameterValue)
    }
  }
  ```

  {{< /tab >}}
{{< /tabs >}}


<h5>Integer Array as String Array</h5>

{{< tabs "intArrayString" >}}
  {{< tab "Before" >}}

  ```bicep
  @allowed([
    '1'
    '2'
    '3'
  ])
  param zones array

  resource myResource '(...)' = {
    (...)
    properties: {
      zones: zones
    }
  }
  ```

  {{< /tab >}}
  {{< tab "After" >}}

  ```bicep
  @allowed([
    1
    2
    3
  ])
  param zones int[]

  resource myResource '(...)' = {
    (...)
    properties: {
      zones: map(zones, zone => string(zone))
    }
  }
  ```

  {{< /tab >}}
{{< /tabs >}}

<br>

---

<br>

## Resource Module Requirements

Listed below are both functional and non-functional requirements for Bicep [AVM Resource Modules](/Azure-Verified-Modules/specs/shared/module-classifications/).

### Non-Functional Requirements (BCPRMNFR)

{{< hint type=note >}}
This section includes **resource module level, non-functional requirements (BCPRMNFR)** for Bicep.
{{< /hint >}}

---

<br>

#### ID: BCPRMNFR1 - Category: Testing - Expected Test Directories

Module owners **MUST** create the `defaults`, `waf-aligned` folders within their `/tests/e2e/` directory in their resource module source code and **SHOULD** create a `max` folder also. Module owners **CAN** create additional folders as required. Each folder will be used as described for various test cases.

##### Defaults tests (**MUST**)

The `defaults` folder contains a test instance that deploys the module with the minimum set of required parameters.

This includes input parameters of type `Required` plus input parameters of type `Conditional` marked as required for WAF compliance.

This instance has heavy reliance on the default values for other input parameters. Parameters of type `Optional` **SHOULD NOT** be used.

##### WAF aligned tests (**MUST**)

The `waf-aligned` folder contains a test instance that deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

This includes input parameters of type `Required`, parameters of type `Conditional` marked as required for WAF compliance, and parameters of type `Optional` useful for WAF compliance.

Parameters and dependencies which are not needed for WAF compliance, **SHOULD NOT** be included.

##### Max tests (**SHOULD**)

The `max` folder contains a test instance that deploys the module using a large parameter set, enabling most of the modules' features.

The purpose of this instance is primarily parameter validation and not necessarily to serve as a real example scenario. Ideally, all features, extension resources and child resources should be enabled in this test, unless not possible due to conflicts, e.g., in case parameters are mutually exclusive.

{{< hint type=note >}}

Please note that this test is not mandatory to have, but recommended for bulk parameter validation. It can be skipped in case the module parameter validation is covered already by additional, more scenario-specific tests.

{{< /hint >}}

##### Additional tests (**CAN**)

Additional folders `CAN` be created by module owners as required.

For example, to validate parameters not covered by the `max` test due to conflicts, or to provide a real example scenario for a specific use case.

If a module can deploy varying styles of the same resource, e.g., VMs can be Linux or Windows, each style should be tested as both `defaults` and `waf-aligned`. These names should be used as suffixes in the directory name to denote the style, e.g., for a VM we would expect to see:

- `/tests/e2e/defaults.linux/main.test.bicep`
- `/tests/e2e/waf-aligned.linux/main.test.bicep`
- `/tests/e2e/defaults.windows/main.test.bicep`
- `/tests/e2e/waf-aligned.windows/main.test.bicep`

<br>

---

<br>
