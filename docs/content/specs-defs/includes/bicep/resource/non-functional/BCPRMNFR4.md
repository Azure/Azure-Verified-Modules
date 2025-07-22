---
title: BCPRMNFR4 - Multi-scope modules
description: Multi-scope Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPRMNFR4
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 13030
---

## ID: BCPRMNFR4 - Implementing multi-scope modules

Several resource types in Azure (e.g., role-assignments, budgets, etc.) may be deployed to more than one scope (e.g., subscription, management-group, etc.).
In AVM, such modules can be implemented in one of two ways:
1. As **pattern modules** with one 'orchestrating' parent module using scoped sub-modules based on the input parameters provided

   > **Note: Only** the parent module is published. I.e., it is not possible to target e.g., the resource-group scoped sub-module directly.

1. As **resource modules** where each scope is implemented as a child-module of a non-published parent.

   > **Note: Each** child module is published, but not the parent. I.e., it is possible to target e.g., the resource-group scoped sub-module directly.

{{% notice style="tip" %}}

It is **highly** recommended to publish multi-scoped modules as resource modules as the solution provides the best user experience.

{{% /notice %}}

### Considerations when published as a pattern module

> **Example:** [avm/<b>ptn</b>/authorization/role-assignment](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/authorization/role-assignment)

> **Note:** The following instructions consider all deployment scopes. Your module may only deploy to a subset of the same and you should map the conventions to your case.

To successfully implement a multi-scoped module as a pattern modules you have to adhere to the following convention:

- The parent module MUST be implemented in the highest scope the resource provider supports (e.g., management-group)
- The parent module MUST have one sub-module for each scope that the resource provider supports (e.g., management-group, subscription & resource-group)
- Each sub-module MUST be implemented for the scope it is intended
- The parent module MUST invoke each sub-module in the scope it is written for, using input parameters needed to target set scope (e.g., a subscription-id to invoke a module for set scope)
- The parent module MUST have test cases to validate each sub-module
- The parent module is the one that is versioned, published and maintains a changelog

The full folder structure may look like
```txt
📄main.bicep                 [Orchestrating module]
📄main.json                  [ARM JSON file of the module]
📄version.json               [Version file of the module]
📄README.md                  [Readme of the module]
📄CHANGELOG.md               [The changelog of the module]
┣ 📂modules
┃ ┣ 📄management-group.bicep [Sub-module deploying to the mgmt-group scope (if applicable)]
┃ ┣ 📄subscription.bicep     [Sub-module deploying to the subscription scope (if applicable)]
┃ ┗ 📄resource-group.bicep   [Sub-module deploying to the resource-group scope (if applicable)]
┗ 📂tests/e2e
  ┣ 📂 mg.defaults
  ┃ ┗ 📄main.test.bicep      [deploys parent template]
  ┣ 📂 mg.waf-aligned
  ┃ ┗ 📄main.test.bicep      [deploys parent template]
  ┣ 📂 sub.defaults
  ┃ ┗ 📄main.test.bicep      [deploys parent template with `subscriptionId` param]
  ┣ 📂 sub.waf-aligned
  ┃ ┗ 📄main.test.bicep      [deploys parent template with `subscriptionId` param]
  ┣ 📂 rg.defaults
  ┃ ┗ 📄main.test.bicep      [deploys parent template with `subscriptionId` & `resourceGroupName` params]
  ┗ 📂 rg.waf-aligned
    ┗ 📄main.test.bicep      [deploys parent template with `subscriptionId` & `resourceGroupName` params]
```

{{% notice style="warning" %}}

Even if a consumer wants to deploy to one of the sub-scopes (e.g., subscription), the module **must** be deployed via its parent (e.g., management-group). This can be confusing for consumers at first and should be considered when implementing the solution.

Example: To use a role-assignment pattern module (which would be written for all scopes, with the parent targeting the management-group scope) to deploy role assignments to a resource group, a user would need to invoke `New-AzManagementGroupDeployment` and provide the parameters for both the subscription & resource-group to target. I.e., the user **must** have permissions to deploy to each scope.

{{% /notice %}}

### Considerations when published as a resource module

> **Example:** [avm/<b>res</b>/authorization/role-assignment](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/authorization/role-assignment)

> **Note:** The following instructions consider all deployment scopes. Your module may only deploy to a subset of the same and you should map the conventions to your case.

To successfully implement a multi-scoped module as a resource modules you have to adhere to the following convention:

- The parent folder MUST contain a
  - `main.bicep` file
  - `main.json` file
  - `README.md` file
  - `tests/e2e` folder
  - One folder per each scope the resource provider can deploy to (either `mg-scope`, `sub-scope` or `rg-scope`).
- Each child-module folder MUST be implemented as a proper child module, with a
  - `main.bicep`
  - `main.json`
  - `version.json`
  - `README.md`
  - `CHANGELOG.md`

  file. Each child-module is maintained and versioned independently of the others.

- The parent `main.bicep` MUST contain the following information

  ```bicep
  metadata name = '<Module Name> (Multi-Scope)'
  metadata description = '''
  This module's child-modules deploy a <Placeholder> at a Management Group (mg-scope), Subscription (sub-scope) or   Resource Group (rg-scope) scope.

  > While this template is **not** published, you can find the actual published modules in the subfolders
  > - `mg-scope`
  > - `sub-scope`
  > - `rg-scope`
  '''
  targetScope = 'managementGroup'
  ```

  updated with your module's specifics

- The `tests/e2e` folder MUST contain one instance of the require test cases per each scope, and MAY contain any additional test you see fit. In each case, the scope MUST be a prefix for the folder name. Each test case MUST reference the corresponding child module directly.

The full folder structure may look like
```txt
📄main.bicep                [Skeleton module with disclaimer referring to the child-modules]
📄main.json                 [ARM JSON file of the module]
📄README.md                 [The baseline readme, surfacing the metadata of the main.bicep file]
┣ 📂mg-scope
┃ ┣📄main.bicep             [Module deploying to mg-scope]
┃ ┣📄main.json              [ARM JSON file of the module]
┃ ┣📄README.md              [Readme of the module]
┃ ┣📄version.json           [Version file of the module]
┃ ┗📄CHANGELOG.md           [The changelog of the module]
┣ 📂sub-scope
┃ ┣📄main.bicep             [Module deploying to sub-scope]
┃ ┣📄main.json              [ARM JSON file of the module]
┃ ┣📄README.md              [Readme of the module]
┃ ┣📄version.json           [Version file of the module]
┃ ┗📄CHANGELOG.md           [The changelog of the module]
┣ 📂rg-scope
┃ ┣📄main.bicep             [Module deploying to rg-scope]
┃ ┣📄main.json              [ARM JSON file of the module]
┃ ┣📄README.md              [Readme of the module]
┃ ┣📄version.json           [Version file of the module]
┃ ┗📄CHANGELOG.md           [The changelog of the module]
┗ 📂tests/e2e
  ┣ 📂mg-scope.defaults
  ┃ ┗📄main.test.bicep      [references the 'mg-scope' child module template: '../../../mg-scope/main.bicep']
  ┣ 📂mg-scope.waf-aligned
  ┃ ┗📄main.test.bicep      [references the 'mg-scope' child module template: '../../../mg-scope/main.bicep']
  ┣ 📂mg-scope.max
  ┃ ┗📄main.test.bicep      [references the 'mg-scope' child module template: '../../../mg-scope/main.bicep']
  ┣ 📂sub-scope.defaults
  ┃ ┗📄main.test.bicep      [references the 'sub-scope' child module template: '../../../sub-scope/main.bicep']
  ┣ 📂sub-scope.waf-aligned
  ┃ ┗📄main.test.bicep      [references the 'sub-scope' child module template: '../../../sub-scope/main.bicep']
  ┣ 📂rg-scope.defaults
  ┃ ┗📄main.test.bicep      [references the 'rg-scope' child module template: '../../../rg-scope/main.bicep']
  ┗ 📂rg-scope.waf-aligned
    ┗📄main.test.bicep      [references the 'rg-scope' child module template: '../../../rg-scope/main.bicep']
```


{{% notice style="important" %}}

Because each child-module is published on its own, you **must** ensure that each is registered in the [MAR-file](https://github.com/microsoft/mcr/blob/main/teams/bicep/bicep.yml) before the modules can be published. Please highlight the nature of your module in the [issue](https://github.com/Azure/Azure-Verified-Modules/issues/new?template=3_module_proposal_avm.yml) when proposing it to AVM.

{{% /notice %}}
