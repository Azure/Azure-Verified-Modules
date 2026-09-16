---
title: UMNFR1 - Module Naming
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/UMNFR1
type: default
tags: [
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 6000
---

## ID: UMNFR1 - Category: Naming - Module Naming

Utility Modules **MUST** follow the below naming conventions (all lower case).

{{% notice style="important" %}}

The module's approved name is captured in the module proposal issue. The related [module index page]({{% siteparam base %}}/indexes) and [CSV file](https://github.com/Azure/Azure-Verified-Modules/tree/main/docs/static/module-indexes) remain published lookup references.

**Module owners must use the name approved in the module proposal, not construct a new one.** If it differs from the index, confirm the correction with the AVM core team.

After [metadata maintenance]({{% siteparam base %}}/contributing/module-metadata/) is adopted, correct supported descriptive fields through a metadata pull request, not by editing the CSV. Module identity and repository paths are derived from the repository; changing `moduleDisplayName` does not rename the module.

{{% /notice %}}

### Bicep Utility Module Naming

- Naming convention: `avm/utl/<hyphenated grouping/category name>/<hyphenated utility module name>`
- Example: `avm/utl/general/get-environment` or `avm/utl/types/avm-common-types`
- Segments:
  - `utl` defines this as a utility module
  - `<hyphenated grouping/category name>` is a hierarchical grouping of utility modules by category, with each word separated by dashes, such as: `general` or `types`
  - `<hyphenated utility module name>` is a term describing the module's function, with each word separated by dashes, e.g., `get-environment` = to get environmental details; `avm-common-types` = to use common types.

### Terraform Utility Module Naming

- Naming convention:
  - `avm-utl-<utility module name>` (Module name for registry)
  - `terraform-<provider>-avm-utl-<utility module name>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-utl-sku-finder` or `avm-utl-naming`
- Segments:
  - `<provider>` is a legacy requirement of the Terraform registry. For AVM Terraform utility modules this **MUST** be set to `azure` (for example `Azure/avm-utl-naming/azure`). Older utility modules may still use the `azurerm` or `azuread` segments. These segments are names only and do not permit use of the AzureRM provider; [TFFR3]({{% siteparam base %}}/spec/TFFR3) still requires every module to be built with AzAPI.
  - `utl` defines this as a utility module
  - `<utility module name>` is a term describing the module's function, e.g., `sku-finder` = to find available SKUs; `naming` = to handle naming conventions.
