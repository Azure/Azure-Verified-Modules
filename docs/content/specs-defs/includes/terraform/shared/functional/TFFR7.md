---
title: TFFR7 - AzAPI - retry and timeouts variables
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR7
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
priority: 20070
---

## ID: TFFR7 - Category: Inputs/Outputs - AzAPI - retry and timeouts variables

These requirements are enforced by [avm_interface_retry]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_interface_retry) and [avm_interface_timeouts]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_interface_timeouts).

### Applicability

TFFR6, TFFR7, and TFFR8 apply independently to each module and submodule scope. Together they require `resource_types`, `retry`, `timeouts`, and `ignore_body_changes` only when that scope directly declares at least one managed `resource` block of a supported AzAPI type:

- `azapi_resource`
- `azapi_data_plane_resource`
- `azapi_resource_action`
- `azapi_update_resource`

A provider declaration alone, AzAPI data sources alone (including `data "azapi_client_config"` and `data "azapi_resource"`), or supported AzAPI resources declared only inside a child module do not trigger these requirements in the parent scope. Each submodule is evaluated independently and triggers when it directly declares a supported block. A `count` or `for_each` condition does not exempt a directly declared block.

Within an applicable scope, the `retry` and `timeouts` blocks of every supported AzAPI resource **MUST** be configurable by the consumer. Authors **MUST NOT** hard-code values inline that the consumer cannot override.

To meet this requirement, the module **MUST** expose two variables:

- `retry` — an object variable controlling the AzAPI `retry` block.
- `timeouts` — an object variable controlling the AzAPI `timeouts` block.

Diff suppression via the AzAPI `ignore_body_changes` argument is covered separately by [TFFR8]({{% siteparam base %}}/spec/TFFR8), because its values are scoped to a single resource's `body` and therefore **MUST NOT** be cascaded to submodules unchanged.

Both variables:

- **MAY** define module-level defaults (e.g., a default `error_message_regex` such as `"ScopeLocked"` for resources that race with lock removal, or a default `delete = "5m"`).
- **MUST** allow the consumer to override the defaults — either by supplying a non-`null` value at the variable level, or by allowing per-field overrides through `optional(...)` attributes.
- **MUST** be applied to every `azapi_resource` (and equivalent AzAPI resources) declared by the module.
- **MUST** cascade to applicable submodules — the parent module's `retry` and `timeouts` values **MUST** be passed through to each submodule it instantiates that directly declares a supported AzAPI resource (see [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)). Submodules **MAY** additionally expose per-item overrides for cases where individual resources need different settings.

```terraform
variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
  })
  default     = null
  description = <<DESCRIPTION
Retry configuration applied to every supported AzAPI resource declared by the module and its applicable submodules. Defaults to `null` (no custom retry).

- `error_message_regex`  - (Optional) A list of regex patterns matching error messages that trigger a retry.
- `interval_seconds`     - (Optional) Initial interval between retries in seconds.
- `max_interval_seconds` - (Optional) Maximum interval between retries in seconds.

See <https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource#retry> for full semantics.
DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Default per-operation timeouts applied to every supported AzAPI resource declared by the module and its applicable submodules. Defaults to `null` (provider defaults). Each value is a Go duration string (e.g. `30m`, `1h`).

- `create` - (Optional) Timeout for create operations.
- `read`   - (Optional) Timeout for read operations.
- `update` - (Optional) Timeout for update operations.
- `delete` - (Optional) Timeout for delete operations.
DESCRIPTION
}

resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  # `retry` is an attribute on `azapi_resource`, so the variable can be
  # assigned directly. `timeouts` is a block, so a `dynamic "timeouts"`
  # block is required to honor the variable's `null` default.
  retry = var.retry

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  response_export_values = []
}

module "child" {
  source = "./modules/child"

  # Cascade retry and timeouts to the submodule.
  retry    = var.retry
  timeouts = var.timeouts

  # ...other arguments...
}
```
