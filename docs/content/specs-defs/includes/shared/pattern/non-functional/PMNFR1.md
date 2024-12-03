---
title: PMNFR1 - Module Naming
url: /spec/PMNFR1
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-Initial, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 4020
---

#### ID: PMNFR1 - Category: Naming - Module Naming

Pattern Modules **MUST** follow the below naming conventions (all lower case):

##### Bicep Pattern Module Naming

- Naming convention: `avm/ptn/<hyphenated grouping/category name>/<hyphenated pattern module name>`
- Example: `avm/ptn/compute/app-tier-vmss` or `avm/ptn/avd-lza/management-plane` or `avm/ptn/3-tier/web-app`
- Segments:
  - `ptn` defines this as a pattern module
  - `<hyphenated grouping/category name>` is a hierarchical grouping of pattern modules by category, with each word separated by dashes, such as:
    - project name, e.g., `avd-lza`,
    - primary resource provider, e.g., `compute` or `network`, or
    - architecture, e.g., `3-tier`
  - `<hyphenated pattern module name>` is a term describing the module’s function, with each word separated by dashes, e.g., `app-tier-vmss` = Application Tier VMSS; `management-plane` = Azure Virtual Desktop Landing Zone Accelerator Management Plane

##### Terraform Pattern Module Naming

- Naming convention:
  - `avm-ptn-<pattern module name>` (Module name for registry)
  - `terraform-<provider>-avm-ptn-<pattern module name>` (GitHub repository name to meet registry naming requirements)
- Example: `avm-ptn-apptiervmss` or `avm-ptn-avd-lza-managementplane`
- Segments:
  - `<provider>` is the logical abstraction of various APIs used by Terraform. In most cases, this is going to be `azurerm` or `azuread` for resource modules.
  - `ptn` defines this as a pattern module
  - `<pattern module name>` is a term describing the module’s function, e.g., `apptiervmss` = Application Tier VMSS; `avd-lza-managementplane` = Azure Virtual Desktop Landing Zone Accelerator Management Plane
