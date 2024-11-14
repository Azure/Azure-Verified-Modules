---
title: BCPNFR15 - AVM Module Issue template file
url: /spec/BCPNFR15
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-Contribution/Support,
  Language-Bicep,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-Maintenance
]
priority: 11140
---

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
