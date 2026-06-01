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

Instead, every AzAPI resource type string used by the module **MUST** be sourced from a single object variable named `resource_types`.

### `resource_types` keys vs Terraform resource labels

These are two unrelated concepts and the spec treats them independently:

- **Keys in `var.resource_types`** name the *AzAPI resource type* and are derived from the ARM type by the naming rule below. They appear on the right of an assignment as the value of the `type` argument.
- **Terraform resource labels** (e.g. `azapi_resource.this`) name the *graph node* and govern how the resource is referenced elsewhere in HCL. The primary resource label **MUST** be `this`, per [TFRMNFR2]({{% siteparam base %}}/spec/TFRMNFR2).

A typical primary-resource declaration therefore reads:

```terraform
resource "azapi_resource" "this" {            # label per TFRMNFR2
  type = var.resource_types.example_widgets   # key per the naming rule below
  # ...
}
```

`this` and `example_widgets` describe different things and are derived by different rules. They **MUST NOT** be made to coincide — `this` is never a valid `resource_types` key.

### Key naming

Each `resource_types` key (at every level of nesting) **MUST** be the snake_case form of the ARM resource type, with the `Microsoft.` prefix dropped:

- Drop the `Microsoft.` prefix.
- Render the provider namespace as a single lowercase token — do **not** split internal camelCase (`KeyVault` → `keyvault`, `DocumentDB` → `documentdb`, `EventHub` → `eventhub`).
- Convert each resource path segment after the provider from camelCase to snake_case (`virtualNetworks` → `virtual_networks`, `roleAssignments` → `role_assignments`).
- Join the provider token and each path segment with `_`.

| ARM type | Key |
|---|---|
| `Microsoft.Example/widgets` | `example_widgets` |
| `Microsoft.Example/widgets/parts` | `example_widgets_parts` |
| `Microsoft.Example/widgets/parts/components` | `example_widgets_parts_components` |
| `Microsoft.Authorization/locks` | `authorization_locks` |
| `Microsoft.Authorization/roleAssignments` | `authorization_role_assignments` |
| `Microsoft.Insights/diagnosticSettings` | `insights_diagnostic_settings` |
| `Microsoft.KeyVault/vaults/secrets` | `keyvault_vaults_secrets` |
| `Microsoft.Network/virtualNetworks/subnets` | `network_virtual_networks_subnets` |

The rule is deterministic so consumers, lint checks and tooling can derive the expected key for any ARM type without consulting the module source. Authors **MUST NOT** invent shorter aliases (e.g. `widgets` instead of `example_widgets`).

### Variable shape

The `resource_types` variable **MUST**:

- Be a single `object({...})` (not a `map(string)`) so typos at call sites error at plan time and per-key defaults are visible in the variable declaration.
- Default the variable itself to `{}` so consumers only need to supply the keys they wish to override.
- Be `nullable = false`.
- Declare one `optional(string, "<provider>/<resource>@<api-version>")` field for every AzAPI resource the module itself declares, defaulting each to the latest API version the module has been tested against. The default **MUST** be a stable (non-preview) API version unless the module's primary resource only ships a preview API.
- Declare one nested `optional(object({...}), {})` field for every submodule the module instantiates (see [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)). The shape of the nested object **MUST** match that submodule's own `resource_types` variable exactly. The parent **MUST NOT** repeat the submodule's defaults — the inner string attributes are declared as `optional(string)` (no default) so the submodule remains the single source of truth for its own tested API versions.
- Document every field in the variable's `description`.

### Cascading to submodules

Because the nested slot in the parent mirrors the submodule's variable, the parent cascades the slot through unchanged:

```terraform
module "part" {
  source         = "./modules/part"
  resource_types = var.resource_types.example_widgets_parts
}
```

No renaming, repacking, or null filtering is required. When the consumer omits a key or sets it explicitly to `null`, Terraform substitutes the default declared on the owning module's variable (per [Terraform's optional-attribute semantics](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes)).

The rationale for the variable is to let consumers:

- Target sovereign clouds (e.g., Azure US Government, Azure China) where older API versions may be the latest available.
- Opt into a newer preview API version without waiting for a module release.
- Pin a specific API version for compliance or reproducibility reasons.

Nesting submodule slots inside the parent's `resource_types` (rather than flattening every AzAPI resource into a single top-level namespace):

- Keeps each module's defaults co-located with the resource it owns.
- Lets a submodule add or rename its own resources without forcing a breaking change on parent-module consumers who never touched those keys.
- Makes the override surface mirror the actual module tree — a consumer looking at the parent's variable can see, in shape, every resource managed beneath it.

### Example — root, child and grandchild

A module managing `Microsoft.Example/widgets`, with a `parts` submodule for `Microsoft.Example/widgets/parts`, which in turn instantiates a `component` sibling submodule for `Microsoft.Example/widgets/parts/components` (per [TFRMNFR1]({{% siteparam base %}}/spec/TFRMNFR1)):

```terraform
# === root variables.tf ===
variable "resource_types" {
  type = object({
    example_widgets     = optional(string, "Microsoft.Example/widgets@2024-01-01")
    authorization_locks = optional(string, "Microsoft.Authorization/locks@2020-05-01")

    example_widgets_parts = optional(object({
      example_widgets_parts            = optional(string)
      example_widgets_parts_components = optional(object({
        example_widgets_parts_components = optional(string)
      }), {})
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
}

module "part" {
  source         = "./modules/part"
  for_each       = var.parts
  name           = each.value.name
  parent_id      = azapi_resource.this.id
  resource_types = var.resource_types.example_widgets_parts
}

# === modules/part/variables.tf ===
variable "resource_types" {
  type = object({
    example_widgets_parts            = optional(string, "Microsoft.Example/widgets/parts@2024-01-01")
    example_widgets_parts_components = optional(object({
      example_widgets_parts_components = optional(string)
    }), {})
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
}

module "component" {
  source         = "../component"
  for_each       = var.components
  name           = each.value.name
  parent_id      = azapi_resource.this.id
  resource_types = var.resource_types.example_widgets_parts_components
}

# === modules/component/variables.tf ===
variable "resource_types" {
  type = object({
    example_widgets_parts_components = optional(string, "Microsoft.Example/widgets/parts/components@2024-01-01")
  })
  default  = {}
  nullable = false
}

# === modules/component/main.tf ===
resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets_parts_components
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }
}
```

A consumer overriding only the grandchild API version writes:

```terraform
module "widget" {
  source = "Azure/avm-res-example-widget/azure"

  resource_types = {
    example_widgets_parts = {
      example_widgets_parts_components = {
        example_widgets_parts_components = "Microsoft.Example/widgets/parts/components@2023-01-01"
      }
    }
  }

  # ...other arguments...
}
```
