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
In AVM, such modules can either be implemented in one of two ways:
1. As **pattern modules** with one 'orchestrating' parent module using scoped sub-modules based on the input parameters provided
   `/main.bicep`: Orchestrating module with the highest target scope (e.g., management-group), accepting parameters like 'subscriptionId' to deploy to lower scopes
   - `/main.json`: The ARM JSON file of the module
   - `/version.json`: The version file of the module
   - `/README.md`: The readme of the module
   - `/CHANGELOG.md`: The changelog of the module
   - `/modules`: Sub-folder to hosted the scoped sub-modules
     - `/management-group.bicep`: Nested sub-module that's deployed to the management-group scope (if applicable)
     - `/subscription.bicep`: Nested sub-module that's deployed to the subscription scope (if applicable)
     - `/resource-group.bicep`: Nested sub-module that's deployed to the resource-group scope (if applicable)

   > **Note: Only** the parent module is published. I.e., it is not possible to target e.g., the resource-group scoped sub-module directly.
   >
   > **Example:** [avm/<b>ptn</b>/authorization/role-assignment](https://github.com/Azure/bicep-registry-modules/tree/main/avm/ptn/authorization/role-assignment)
1. As **resource modules** where each scope is implemented as a child-module of a non-published parent.
   - `/main.bicep`: Empty parent template with a disclaimer referring to the child-modules.
   - `/mg-scope`: Nested child-module folder hosting the files of the management-group-scoped child-module (if applicable)
     - `/main.bicep`: The management-group-scoped child-module template
     - `/main.json`: The ARM JSON file of the module
     - `/version.json`: The version file of the module
     - `/README.md`: The readme of the module
     - `/CHANGELOG.md`: The changelog of the module
   - `/sub-scope`: Nested child-module folder hosting the files of the subscription-scoped child-module (if applicable)
     - `/main.bicep`: The subscription-scoped child-module template
     - `/main.json`: The ARM JSON file of the module
     - `/version.json`: The version file of the module
     - `/README.md`: The readme of the module
     - `/CHANGELOG.md`: The changelog of the module
   - `/rg-scope`: Nested child-module folder hosting the files of the resource-group-scoped child-module (if applicable)
     - `/main.bicep`: The resource-group-scoped child-module template
     - `/main.json`: The ARM JSON file of the module
     - `/version.json`: The version file of the module
     - `/README.md`: The readme of the module
     - `/CHANGELOG.md`: The changelog of the module
   > **Note: Each** child module is published, but not the parent. I.e., it is possible to target e.g., the resource-group scoped sub-module directly.
   >
   > **Example:** [avm/<b>res</b>/authorization/role-assignment](https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/authorization/role-assignment)

{{% notice style="important" %}}

It is **highly** recommended to publish multi-scoped modules as resource modules as the solution provides the best user experience.

{{% /notice %}}

### Additional considerations when published as a resource module

To successfully implement a multi-scoped module as a resource modules you have to adhere to the following convention:

> **Note:** The following instructions consider all deployment scopes. Your module may only deploy to a subset of the same and you should map the conventions to your case.


- The parent folder MUST contain a `README.md`, `main.bicep`, `main.json` file, the `tests` folder and one folder per each scope the resource provider can deploy to (either `mg-scope`, `sub-scope` or `rg-scope`).
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

- The `tests/e2e` folder MUST contain one instance of the require test cases per each scope, and MAY contain any additional test you see fit. In each case, the scope MUST be a prefix for the folder name. Each test case MUST reference the corresponding child module directly. For example
  ```txt
  📂tests/e2e
  ┣ 📂mg-scope.defaults [mg-scope]
  ┃ ┗📄main.test.bicep [references the 'mg-scope' child module template: '../../../mg-scope/main.bicep']
  ┣ 📂mg-scope.waf-aligned [mg-scope]
  ┃ ┗📄main.test.bicep [references the 'mg-scope' child module template: '../../../mg-scope/main.bicep']
  ┣ 📂mg-scope.max [mg-scope]
  ┃ ┗📄main.test.bicep [references the 'mg-scope' child module template: '../../../mg-scope/main.bicep']
  ┣ 📂sub-scope.defaults [sub-scope]
  ┃ ┗📄main.test.bicep [references the 'sub-scope' child module template: '../../../sub-scope/main.bicep']
  ┣ 📂sub-scope.waf-aligned [sub-scope]
  ┃ ┗📄main.test.bicep [references the 'sub-scope' child module template: '../../../sub-scope/main.bicep']
  ┣ 📂rg-scope.defaults [rg-scope]
  ┃ ┗📄main.test.bicep [references the 'rg-scope' child module template: '../../../rg-scope/main.bicep']
  ┗ 📂rg-scope.waf-aligned [rg-scope]
    ┗📄main.test.bicep [references the 'rg-scope' child module template: '../../../rg-scope/main.bicep']
  ```

