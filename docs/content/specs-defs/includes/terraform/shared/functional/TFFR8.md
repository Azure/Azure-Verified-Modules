---
title: TFFR8 - AzAPI - ignore_body_changes variable
description: Module Specification for the Azure Verified Modules (AVM) program
url: /spec/TFFR8
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
priority: 20080
---

## ID: TFFR8 - Category: Inputs/Outputs - AzAPI - ignore_body_changes variable

This requirement is enforced by [avm_interface_ignore_body_changes]({{% siteparam base %}}/contributing/terraform/tflint-rules/#avm_interface_ignore_body_changes).

### Applicability

TFFR6, TFFR7, and TFFR8 apply independently to each module and submodule scope. Together they require `resource_types`, `retry`, `timeouts`, and `ignore_body_changes` only when that scope directly declares at least one managed `resource` block of a supported AzAPI type:

- `azapi_resource`
- `azapi_data_plane_resource`
- `azapi_resource_action`
- `azapi_update_resource`

A provider declaration alone, AzAPI data sources alone (including `data "azapi_client_config"` and `data "azapi_resource"`), or supported AzAPI resources declared only inside a child module do not trigger these requirements in the parent scope. Each submodule is evaluated independently and triggers when it directly declares a supported block. A `count` or `for_each` condition does not exempt a directly declared block.

Within an applicable scope, the `ignore_body_changes` argument of every supported AzAPI resource **MUST** be configurable by the consumer. Authors **MUST NOT** hard-code an inline list that the consumer cannot override, and **MUST NOT** omit the argument.

To meet this requirement, every applicable module or submodule (see [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)) **MUST** expose a variable named `ignore_body_changes`.

`ignore_body_changes` lets a consumer suppress plan diffs for a set of body paths that are mutated outside Terraform (for example tags applied by Azure Policy, or an autoscaler adjusting a capacity property). It is the supported fallback for `lifecycle.ignore_changes` when the paths must be derived from variables, locals or other non-static values, which `lifecycle` blocks cannot accept.

Without this variable a consumer has no way to reach the argument, because `lifecycle.ignore_changes` cannot be applied to a resource from outside the module that declares it. This is exactly the same problem that [TFFR7]({{% siteparam base %}}/spec/TFFR7) solves for `retry` and `timeouts`.

### Prerequisites

`ignore_body_changes` is a [write-only argument](https://developer.hashicorp.com/terraform/language/resources/ephemeral#write-only-arguments). As a result:

- The module's `Azure/azapi` constraint in `required_providers` **MUST** allow v2.12.0 or later, which is the release that introduces the argument (see [TFFR3]({{% siteparam base %}}/spec/TFFR3)).
- A consumer supplying a **non-empty** value **MUST** be running Terraform 1.11 or later. Modules **MUST NOT** raise their `required_version` floor for this reason alone (see [TFNFR25]({{% siteparam base %}}/spec/TFNFR25)); instead they **MUST** emit `null` when the list is empty so that consumers on earlier Terraform versions who do not use the feature are unaffected. See [Applying the variable](#applying-the-variable).

{{% notice style="important" %}}

Because the value is held in provider-private state, a change to `ignore_body_changes` only takes effect **after** an apply. A consumer who adds a path will still see the pending diff for that path in the same plan, and a consumer who removes a path will not see the suppressed diff reappear until the next plan. Module documentation **SHOULD** call this out.

{{% /notice %}}

### Variable shape

Unlike `retry` and `timeouts`, which are resource-agnostic and therefore cascade unchanged, `ignore_body_changes` values are dot-notation paths into **one specific resource's** `body`. A path such as `properties.addressSpace` is meaningful only for the resource that owns it, so passing a parent's list straight through to a submodule would apply meaningless paths to a different resource.

The variable is therefore scoped per resource and per submodule, using exactly the same shape and key-naming rule as `resource_types` ([TFFR6]({{% siteparam base %}}/spec/TFFR6)).

The `ignore_body_changes` variable **MUST**:

- Be a single `object({...})` (not a `map(list(string))`) so typos at call sites error at plan time and the full override surface is visible in the variable declaration.
- Default the variable itself to `{}` and be `nullable = false`, per [TFNFR20]({{% siteparam base %}}/spec/TFNFR20) and [TFNFR21]({{% siteparam base %}}/spec/TFNFR21).
- Declare one `optional(list(string), [])` field for every AzAPI resource the module itself declares, keyed by the snake_case form of the ARM resource type with the `Microsoft.` prefix dropped — the identical key used in `resource_types` (for example `Microsoft.Example/widgets` → `example_widgets`).
- Declare one nested `optional(object({...}), {})` field for every submodule the module instantiates that directly declares a supported AzAPI resource, keyed by that submodule's primary ARM resource type. The shape of the nested object **MUST** match that submodule's own `ignore_body_changes` variable exactly, and the parent **MUST** cascade the slot through unchanged.
- Document every field in the variable's `description`, including what `ignore_body_changes` does, that paths use dot notation, and that changes take effect only after an apply.

Module owners **MAY** ship module-level defaults where the resource is known to be mutated outside Terraform. To do so, supply the default inside the `optional(list(string), [...])` wrapper. Consumers **MUST** still be able to override any individual field, and a module-level default **MUST NOT** be used to work around a bug that belongs in the module body.

Modules **MAY** additionally expose per-item overrides on the collection variable that drives a `for_each` submodule, for cases where individual instances need different paths. Where they do, the per-item value **MUST** take precedence over the shared slot.

### Path syntax

Values are dot-notation paths relative to the resource's `body`, for example `tags` or `properties.sku.name`. Each element **MUST** be a non-empty string.

Individual list items **MUST NOT** be targeted (there is no index syntax) — ignore the entire list property instead.

Authors and consumers **MUST** understand that an ignored path is not merely hidden from the plan: configuration changes at that path are **not sent to Azure** until the path is removed from the list.

### Applying the variable

`ignore_body_changes` is an attribute (not a block) on `azapi_resource`, so the relevant field of the variable is assigned directly. The assignment **MUST** collapse an empty list to `null` so that the write-only argument is absent when the feature is unused:

```terraform
ignore_body_changes = length(var.ignore_body_changes.example_widgets) > 0 ? var.ignore_body_changes.example_widgets : null
```

The variable **MUST** be applied to every `azapi_resource` (and equivalent AzAPI resources) declared by the module.

### Example — root and child

```terraform
# === root variables.tf ===
variable "ignore_body_changes" {
  type = object({
    example_widgets = optional(list(string), [])

    example_widgets_parts = optional(object({
      example_widgets_parts = optional(list(string), [])
    }), {})
  })
  default  = {}
  nullable = false
}

# === root main.tf ===
resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  ignore_body_changes = length(var.ignore_body_changes.example_widgets) > 0 ? var.ignore_body_changes.example_widgets : null

  response_export_values = []
}

module "part" {
  source   = "./modules/part"
  for_each = var.parts

  name           = each.value.name
  parent_id      = azapi_resource.this.id
  resource_types = var.resource_types.example_widgets_parts
  retry          = var.retry
  timeouts       = var.timeouts

  # Cascade the nested slot through unchanged.
  ignore_body_changes = var.ignore_body_changes.example_widgets_parts
}

# === modules/part/variables.tf ===
variable "ignore_body_changes" {
  type = object({
    example_widgets_parts = optional(list(string), [])
  })
  default  = {}
  nullable = false
}

# === modules/part/main.tf ===
resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets_parts
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  ignore_body_changes = length(var.ignore_body_changes.example_widgets_parts) > 0 ? var.ignore_body_changes.example_widgets_parts : null

  response_export_values = []
}
```

A consumer ignoring tags on the widget, and a policy-managed property on every part, writes:

```terraform
module "widget" {
  source = "Azure/avm-res-example-widget/azure"

  ignore_body_changes = {
    example_widgets = var.ignore_policy_tags ? ["tags"] : []

    example_widgets_parts = {
      example_widgets_parts = ["properties.retentionPolicy"]
    }
  }

  # ...other arguments...
}
```

See <https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource#ignore_body_changes> for full semantics.
