# `ignore_body_changes` keys follow exactly the same naming rule as
# `resource_types` (see TFFR6): the snake_case form of the ARM resource type
# with the `Microsoft.` prefix dropped.
#
#   Microsoft.Example/widgets                  -> example_widgets
#   Microsoft.Example/widgets/parts            -> example_widgets_parts
#   Microsoft.Example/widgets/parts/components -> example_widgets_parts_components
#
# Unlike `retry` and `timeouts`, the values are dot-notation paths into ONE
# specific resource's `body`, so the variable is scoped per resource and per
# submodule instead of being cascaded unchanged. Every submodule the module
# instantiates gets a nested `optional(object({...}), {})` slot whose shape
# matches that submodule's own `ignore_body_changes` variable exactly, and the
# parent cascades that slot through unchanged.

variable "ignore_body_changes" {
  type = object({
    example_widgets = optional(list(string), [])

    example_widgets_parts = optional(object({
      example_widgets_parts = optional(list(string), [])
    }), {})
  })
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
Paths in each resource's `body` whose changes the AzAPI provider ignores. Prefer Terraform's `lifecycle.ignore_changes` when the paths are static; use this variable when the paths must be derived from variables or other non-static values.

Paths use dot notation, for example `properties.sku.name`. Individual list items cannot be targeted — ignore the whole list property instead. Configuration changes at an ignored path are **not** sent to Azure until that path is removed from the list.

Supplying a non-empty value requires Terraform 1.11 or later, because `ignore_body_changes` is a write-only argument. Changes take effect only after an apply, because the value is held in provider-private state.

- `example_widgets`       - Ignored body paths for the widget managed by this module.
- `example_widgets_parts` - Override slot for the `parts` submodule. Supply only the keys you want to override.
  - `example_widgets_parts` - Ignored body paths for the part resource managed by the `parts` submodule.
DESCRIPTION
}

# `ignore_body_changes` is a write-only attribute on `azapi_resource`, so the
# relevant field is assigned directly. Collapse an empty list to `null` so the
# argument is absent when the feature is unused, keeping the module usable on
# Terraform versions earlier than 1.11.
resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  ignore_body_changes = length(var.ignore_body_changes.example_widgets) > 0 ? var.ignore_body_changes.example_widgets : null

  response_export_values = []
}

# Cascade the nested slot to the submodule unchanged. The submodule's
# `ignore_body_changes` variable has exactly the shape of the slot, so no
# repacking or renaming is required.
module "part" {
  source   = "./modules/part"
  for_each = var.parts

  name                = each.value.name
  parent_id           = azapi_resource.this.id
  resource_types      = var.resource_types.example_widgets_parts
  ignore_body_changes = var.ignore_body_changes.example_widgets_parts
}
