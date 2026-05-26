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

Authors **MUST** only use the following Azure providers, and versions, in their modules:

| provider              | min version | max version |
|-----------------------|-------------|-------------|
| Azure/azapi           | >= 2.0      | < 3.0       |

The AzureRM provider **MUST NOT** be used, except where the narrow exception below applies.

### Exception — AzureRM for resources with no AzAPI equivalent

An AVM Terraform module **MAY** declare the AzureRM provider **only** for resources whose functionality is genuinely unavailable through any AzAPI resource — that is, where there is no equivalent in `azapi_resource`, `azapi_data_plane_resource`, `azapi_resource_action`, or `azapi_update_resource`. In practice this is limited to a small set of edge cases, most commonly data-plane operations such as Key Vault secrets and certificates, Storage blobs, and a handful of resources whose `azurerm_*` implementation calls non-ARM APIs.

Where this exception applies the module **MUST**:

- Pin the AzureRM provider to `~> 4.0` in `required_providers`.
- Use AzAPI for *every* resource that has an AzAPI equivalent. AzureRM **MUST NOT** be used as a convenience alternative to AzAPI.
- Document the exception in the module's `README.md`, listing each `azurerm_*` resource used, the data-plane / non-ARM API it wraps, why no AzAPI equivalent exists today, and the upstream AzAPI issue or PR tracking the eventual replacement.
- Replace each `azurerm_*` resource with its AzAPI equivalent as soon as one becomes available, in the next module release after the AzAPI capability ships.
- Add the following TFLint exclusion (only required because the AzureRM provider is otherwise blocked by AVM tooling):

  ```hcl
  rule "provider_azurerm_disallowed" {
    enabled = false
  }
  ```

This exception **MUST NOT** be used to:

- Avoid migrating an existing AzureRM resource that *does* have an AzAPI equivalent.
- Reduce author effort where the AzAPI body schema is more verbose than the AzureRM resource.
- Side-step any other AzAPI-specific spec (for example [TFFR4]({{% siteparam base %}}/spec/TFFR4), [TFFR5]({{% siteparam base %}}/spec/TFFR5), [TFFR6]({{% siteparam base %}}/spec/TFFR6), or [TFFR7]({{% siteparam base %}}/spec/TFFR7)) — those rules continue to apply to every AzAPI resource the module declares, regardless of whether the module also uses AzureRM under this exception.

Authors **MUST** use the `required_providers` block in their module to enforce the provider versions.

The following is an example.

- In it we use the [pessimistic version constraint operator](https://developer.hashicorp.com/terraform/language/expressions/version-constraints#operators) `~>`.
- That is to say that `~> 2.9` is equivalent to `>= 2.9, < 3.0`.

```terraform
terraform {
  required_providers {
    # Include one or both providers, as needed
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.9"
    }
  }
}
```
