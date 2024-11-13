---
title: RMNFR1 - Module Naming
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: [
  Class-Resource,
  Type-NonFunctional,
  Category-Naming,
  Language-Bicep,
  Language-Terraform,
  Severity-MUST,
  Persona-Owner,
  Lifecycle-Initial
]
type: "posts"
---

#### ID: RMNFR1 - Category: Naming - Module Naming

{{< hint type=note >}}

We will maintain a set of CSV files in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) with the correct singular names for all resource types to enable checks to utilize this list to ensure repos are named correctly. To see the formatted content of these CSV files with additional information, please visit the [AVM Module Indexes](/Azure-Verified-Modules/indexes) page.

This will be updated quarterly, or ad-hoc as new RPs/ Resources are created and highlighted via a check failure.

{{< /hint >}}

Resource modules **MUST** follow the below naming conventions (all lower case):

##### Bicep Resource Module Naming

- Naming convention: `avm/res/<hyphenated resource provider name>/<hyphenated ARM resource type>` (module name for registry)
- Example: `avm/res/compute/virtual-machine` or `avm/res/managed-identity/user-assigned-identity`
- Segments:
  - `res` defines this is a resource module
  - `<hyphenated resource provider name>` is the resource provider’s name after the `Microsoft` part, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute` = `compute`, `Microsoft.ManagedIdentity` = `managed-identity`.
  - `<hyphenated ARM resource type>` is the **singular** version of the word after the resource provider, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute/virtualMachines` = `virtual-machine`, **BUT** `Microsoft.Network/trafficmanagerprofiles` = `trafficmanagerprofile` - since `trafficmanagerprofiles` is all lower case as per the ARM API definition.

##### Terraform Resource Module Naming

- Naming convention:
  - `avm-res-<resource provider>-<ARM resource type>` (module name for registry)
  - `terraform-<provider>-avm-res-<resource provider>-<ARM resource type>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-res-compute-virtualmachine` or `avm-res-managedidentity-userassignedidentity`
- Segments:
  - `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` or `azuread` for resource modules.
  - `res` defines this is a resource module
  - `<resource provider>` is the resource provider’s name after the `Microsoft` part, e.g., `Microsoft.Compute` = `compute`.
  - `<ARM resource type>` is the **singular** version of the word after the resource provider, e.g., `Microsoft.Compute/virtualMachines` = `virtualmachine`
