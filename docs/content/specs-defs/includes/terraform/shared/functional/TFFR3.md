---
title: TFFR3 - Providers - Permitted Versions
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR3
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Naming/Composition, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TF/CI/Enforced # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 20030
---

## ID: TFFR3 - Category: Providers - Permitted Versions

{{% notice style="important" %}}

Every new AVM Terraform module — resource, pattern, or utility — **MUST** use `Azure/azapi` for every Azure resource it declares. The module repository **MUST NOT** declare or configure the `hashicorp/azurerm` provider, or declare any `azurerm_*` resource or data source.

{{% /notice %}}

Authors **MUST** only use the following Azure providers, and versions, in their modules:

| provider              | min version | max version |
|-----------------------|-------------|-------------|
| Azure/azapi           | >= 2.12     | < 3.0       |

{{% notice style="note" %}}

The AzAPI floor is `2.12` because [TFFR8]({{% siteparam base %}}/spec/TFFR8) requires every module to expose the `ignore_body_changes` argument, which was introduced in `Azure/azapi` v2.12.0. Modules pinned below that version will fail to plan because the argument is absent from the provider schema.

{{% /notice %}}

This prohibition applies to every Terraform configuration shipped with the module, including:

- The root module and all submodules.
- Every configuration under `examples/`, including examples executed as end-to-end tests.
- Terraform tests, test fixtures, and supporting setup configurations.
- Terraform snippets in `_header.md`, `_footer.md`, generated documentation, and other repository documentation.

Authors **MUST NOT** add a `hashicorp/azurerm` entry to `required_providers`, configure an `azurerm` provider block, or use any `azurerm_*` resource or data source in those locations. Supporting Azure resources needed by an example, end-to-end test, or fixture **MUST** use AzAPI.

If AzAPI cannot perform a required operation, authors **MUST NOT** fall back to AzureRM. They **MUST** treat the operation as an AzAPI capability gap, raise it with the AzAPI maintainers, and omit or redesign the functionality until an AzAPI implementation is available.

The `azurerm` remote state backend and the final segment of a published Terraform Registry module address, such as `/azurerm` in an existing AVM module source, are names and are not provider declarations. They **MAY** appear where required for state storage or to reference an existing published AVM module. A dependency's provider implementation is governed by that dependency's own repository; its Registry address does not permit the consuming module repository to declare or configure `hashicorp/azurerm`, or to add any `azurerm_*` block.

Authors **MUST** use the `required_providers` block in their module to enforce the provider versions.

The following is an example.

- In it we use the [pessimistic version constraint operator](https://developer.hashicorp.com/terraform/language/expressions/version-constraints#operators) `~>`.
- That is to say that `~> 2.12` is equivalent to `>= 2.12, < 3.0`.

```terraform
terraform {
  required_providers {
    # AzAPI is required for every AVM Terraform module.
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
  }
}
```
