---
title: TFFR6 - AzAPI - resource_types variable
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR6
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Utility, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-Functional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Inputs/Outputs, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Persona-Contributor, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE: this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 20060
---

## ID: TFFR6 - Category: Inputs/Outputs - AzAPI - resource_types variable

Authors **MUST NOT** hard-code the `type` argument of an `azapi_resource` (or `azapi_data_plane_resource`, `azapi_resource_action`, `azapi_update_resource`) inline.

Instead, every AzAPI resource type string used by the module **MUST** be sourced from a single object variable named `resource_types`. This variable **MUST**:

- Have one `optional(string, "<provider>/<resource>@<api-version>")` field per `azapi_resource` declared by the module (and by its submodules — see [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)).
- Default each field to the latest API version that the module has been tested against. The default **MUST** be a stable (non-preview) API version unless the module's primary resource only ships a preview API.
- Default the variable itself to `{}` so consumers only need to supply the keys they wish to override.
- Be `nullable = false`.
- Document each field in the variable's `description`, including the resource it controls.

The rationale is to allow consumers to:

- Target sovereign clouds (e.g., Azure US Government, Azure China) where older API versions may be the latest available.
- Opt into a newer preview API version without waiting for a module release.
- Pin a specific API version for compliance or reproducibility reasons.

Parent modules **MUST** cascade the relevant subset of `resource_types` to each submodule they instantiate, so that submodule API versions remain consistent with the parent's chosen versions and a single override at the parent level propagates everywhere.

```terraform
variable "resource_types" {
  type = object({
    widget = optional(string, "Microsoft.Example/widgets@2024-01-01")
    part   = optional(string, "Microsoft.Example/widgets/parts@2024-01-01")
    lock   = optional(string, "Microsoft.Authorization/locks@2020-05-01")
  })
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
Override the AzAPI `<provider>/<resource>@<api-version>` strings used by this module. Each key defaults to a tested value; supply only the keys you want to override. Useful when targeting a sovereign cloud with older API versions, or when opting into a newer preview API.

- `widget` - The primary resource managed by this module.
- `part`   - Child resources of the primary resource.
- `lock`   - Management lock applied to the primary resource and its private endpoints.
DESCRIPTION
}

resource "azapi_resource" "this" {
  type      = var.resource_types.widget
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }
}

module "part" {
  source = "./modules/part"

  # Cascade the relevant subset to the submodule.
  resource_types = {
    this = var.resource_types.part
  }

  # ...other arguments...
}
```
