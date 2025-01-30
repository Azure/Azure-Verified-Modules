---
title: RMNFR1 - Module Naming
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/RMNFR1
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 3010
---

## ID: RMNFR1 - Category: Naming - Module Naming

{{% notice style="note" %}}

We will maintain a set of CSV files in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) with the correct singular names for all resource types to enable checks to utilize this list to ensure repos are named correctly. To see the formatted content of these CSV files with additional information, please visit the [AVM Module Indexes]({{% siteparam base %}}/indexes) page.

This will be updated quarterly, or ad-hoc as new RPs/ Resources are created and highlighted via a check failure.

{{% /notice %}}

Resource modules **MUST** follow the below naming conventions (all lower case):

### Bicep Resource Module Naming

- Naming convention: `avm/res/<hyphenated resource provider name>/<hyphenated ARM resource type>` (module name for registry)
- Example: `avm/res/compute/virtual-machine` or `avm/res/managed-identity/user-assigned-identity`
- Segments:
  - `res` defines this is a resource module
  - `<hyphenated resource provider name>` is the resource provider’s name after the `Microsoft` part, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute` = `compute`, `Microsoft.ManagedIdentity` = `managed-identity`.
  - `<hyphenated ARM resource type>` is the **singular** version of the word after the resource provider, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute/virtualMachines` = `virtual-machine`, **BUT** `Microsoft.Network/trafficmanagerprofiles` = `trafficmanagerprofile` - since `trafficmanagerprofiles` is all lower case as per the ARM API definition.

### Terraform Resource Module Naming

- Naming convention:
  - `avm-res-<resource provider>-<ARM resource type>` (module name for registry)
  - `terraform-<provider>-avm-res-<resource provider>-<ARM resource type>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-res-compute-virtualmachine` or `avm-res-managedidentity-userassignedidentity`
- Segments:
  - `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` or `azuread` for resource modules.
  - `res` defines this is a resource module
  - `<resource provider>` is the resource provider’s name after the `Microsoft` part, e.g., `Microsoft.Compute` = `compute`.
  - `<ARM resource type>` is the **singular** version of the word after the resource provider, e.g., `Microsoft.Compute/virtualMachines` = `virtualmachine`
