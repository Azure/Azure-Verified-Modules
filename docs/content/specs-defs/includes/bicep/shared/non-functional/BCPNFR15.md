---
title: BCPNFR15 - AVM Module Issue template file
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/BCPNFR15
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
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

The `module-name-dropdown` in the [BRM AVM Module Issue template](https://github.com/Azure/bicep-registry-modules/blob/main/.github/ISSUE_TEMPLATE/avm_module_issue.yml) **MUST** list top-level Bicep modules with `Available` or `Orphaned` status, sorted by module class and name. Proposed, deprecated, and child modules are excluded.

The [module list sync workflow](https://github.com/Azure/azure-verified-modules-tools/blob/main/.github/workflows/repository-management-module-list-sync.yml) compares the dropdown with the [published module catalog](https://github.com/Azure/Azure-Verified-Modules/blob/main/docs/static/module-indexes/v1/modules.json) and updates it through a verified, auto-merged bot pull request. Module owners maintain [root metadata]({{% siteparam base %}}/contributing/module-metadata/) and the required publication or deprecation evidence instead of editing the dropdown directly.
