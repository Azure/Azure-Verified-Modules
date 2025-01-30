---
title: BCPNFR15 - AVM Module Issue template file
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPNFR15
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Contribution/Support, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced"
]
priority: 11140
---

## ID: BCPNFR15 - Category: Contribution/Support - AVM Module Issue template file

As part of the "initial Pull Request" (that publishes the first version of the module), module owners **MUST** add an entry to the `AVM Module Issue template` file in the BRM repository ([here](https://github.com/Azure/bicep-registry-modules/blob/main/.github/ISSUE_TEMPLATE/avm_module_issue.yml)).

{{% notice style="note" %}}

Through this approach, the AVM core team will allow raising a bug or feature request for a module, only after the module gets merged to the [BRM](https://aka.ms/BRM) repository.

{{% /notice %}}

The module name entry **MUST** be added to the dropdown list with id `module-name-dropdown` as an option, in alphabetical order.

{{% notice style="important" %}}

Module owners **MUST** ensure that the module name is added in alphabetical order, to simplify selecting the right module name when raising an AVM module issue.

{{% /notice %}}

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
