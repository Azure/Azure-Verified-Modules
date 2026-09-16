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

Resource modules **MUST** follow the below naming conventions (all lower case).

{{% notice style="important" %}}

The module's approved name is captured in the module proposal issue. The related [module index page]({{% siteparam base %}}/indexes) and [CSV file](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) remain published lookup references.

**Module owners must use the name approved in the module proposal, not construct a new one.** If it differs from the index, confirm the correction with the AVM core team.

After [metadata maintenance]({{% siteparam base %}}/contributing/module-metadata/) is adopted, correct supported descriptive fields through a metadata pull request, not by editing the CSV. Module identity and repository paths are derived from the repository; changing `moduleDisplayName` does not rename the module.

{{% /notice %}}

{{% notice style="note" %}}

The CSV files in the [AVM Central Repo (`Azure/Azure-Verified-Modules`)](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) remain available for checks that use the approved singular resource names. To see their formatted content with additional information, visit the [AVM Module Indexes]({{% siteparam base %}}/indexes) page.

After the metadata transition, index updates come through catalog generation and reviewed publication. Report missing or incorrect resource names to the AVM core team rather than changing a module's approved name or editing a generated CSV.

{{% /notice %}}

### Bicep Resource Module Naming

- Naming convention (module name for registry): `avm/res/<hyphenated resource provider name>/<hyphenated ARM resource type>`
- Example: `avm/res/compute/virtual-machine` or `avm/res/managed-identity/user-assigned-identity`
- Segments:
  - `res` defines this is a resource module
  - `<hyphenated resource provider name>` is the resource provider's name after the `Microsoft` part, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute` = `compute`, `Microsoft.ManagedIdentity` = `managed-identity`.
  - `<hyphenated ARM resource type>` is the **singular** version of the word after the resource provider, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Compute/virtualMachines` = `virtual-machine`, **BUT** `Microsoft.Network/trafficmanagerprofiles` = `trafficmanagerprofile` - since `trafficmanagerprofiles` is all lower case as per the ARM API definition.

#### Bicep Child Module Naming

- Naming convention (module name for registry):`avm/res/<hyphenated resource provider name>/<hyphenated ARM resource type>/` `<hyphenated child resource type/<hyphenated grandchild resource type>/<etc.>`

- Example: `avm/res/network/virtual-network/subnet` or `avm/res/storage/storage-account/blob-service/container`
- Segments:
  - `res` defines this is a resource module
  - `<hyphenated resource provider name>` is the resource provider's name after the `Microsoft` part, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Network` = `network`.
  - `<hyphenated ARM resource type>` is the **singular** version of the word after the resource provider, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Network/virtualNetworks` = `virtual-network`.
  - `<hyphenated child resource type (to be repeated for grandchildren, etc.)>` is the **singular** version of the word after the resource provider, with each word starting with a capital letter separated by dashes, e.g., `Microsoft.Network/virtualNetworks/subnets` = `subnet` or `Microsoft.Storage/storageAccounts/blobServices/containers` = `blob-service/container`.

### Terraform Resource Module Naming

- Naming convention:
  - `avm-res-<resource provider>-<ARM resource type>` (module name for registry)
  - `terraform-<provider>-avm-res-<resource provider>-<ARM resource type>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-res-compute-virtualmachine` or `avm-res-managedidentity-userassignedidentity`
- Segments:
  - `<provider>` is a legacy requirement of the Terraform registry. This must be set to `azure`
  - `res` defines this is a resource module
  - `<resource provider>` is the resource provider's name after the `Microsoft` part, e.g., `Microsoft.Compute` = `compute`.
  - `<ARM resource type>` is the **singular** version of the word after the resource provider, e.g., `Microsoft.Compute/virtualMachines` = `virtualmachine`
