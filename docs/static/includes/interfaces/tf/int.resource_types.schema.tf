# `resource_types` keys vs Terraform resource labels
# -----------------------------------------------------------------------------
# These are two unrelated concepts:
#
#   - Keys in `var.resource_types` name the AzAPI resource TYPE (e.g.
#     `example_widgets`). They are derived from the ARM resource type by
#     the naming rule below.
#   - The Terraform resource LABEL (e.g. `azapi_resource.this`) names the
#     graph node. The primary resource label MUST be `this` per TFRMNFR2.
#
# A primary-resource declaration therefore reads:
#
#   resource "azapi_resource" "this" {            # label per TFRMNFR2
#     type = var.resource_types.example_widgets   # key per the naming rule
#   }
#
# The two MUST NOT be conflated. `this` is never a valid `resource_types` key.
#
# Naming rule for `resource_types` keys
# -----------------------------------------------------------------------------
# Each key MUST be the snake_case form of the ARM resource type with the
# `Microsoft.` prefix dropped. The provider namespace is rendered as a single
# lowercase token (no internal split) and each path segment after the
# provider is converted from camelCase to snake_case. Segments are joined
# with `_`:
#
#   Microsoft.Example/widgets                  -> example_widgets
#   Microsoft.Example/widgets/parts            -> example_widgets_parts
#   Microsoft.Example/widgets/parts/components -> example_widgets_parts_components
#   Microsoft.Authorization/locks              -> authorization_locks
#   Microsoft.Authorization/roleAssignments    -> authorization_role_assignments
#   Microsoft.Insights/diagnosticSettings      -> insights_diagnostic_settings
#   Microsoft.KeyVault/vaults/secrets          -> keyvault_vaults_secrets
#   Microsoft.Network/virtualNetworks/subnets  -> network_virtual_networks_subnets
#
# Submodules in the variable
# -----------------------------------------------------------------------------
# Every submodule the module instantiates gets a nested `optional(object({...}), {})`
# slot in `resource_types`, keyed by the submodule's primary ARM resource type
# (same naming rule). The slot's shape MUST match the submodule's own
# `resource_types` variable exactly. The parent MUST NOT repeat the submodule's
# defaults: the inner string attributes are declared as `optional(string)`
# with no default, so the submodule remains the single source of truth for
# its own tested API versions. Passing `null` (or omitting the key) yields
# the submodule's default.

# Root module example: manages `Microsoft.Example/widgets`, owns one extension
# resource (a lock), and instantiates a `parts` submodule that itself
# instantiates a `component` sibling submodule (per TFRMNFR1).
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
  description = <<DESCRIPTION
Override the AzAPI `<provider>/<resource>@<api-version>` strings used by this module and its submodules. Each key defaults to a tested value; supply only the keys you want to override. Useful when targeting a sovereign cloud with older API versions, or when opting into a newer preview API.

- `example_widgets`     - The primary widget managed by this module.
- `authorization_locks` - Management lock applied to the widget and its private endpoints.
- `example_widgets_parts` - Override slot for the `parts` submodule. Defaults live in the submodule; supply only the keys you want to override.
  - `example_widgets_parts`            - The part resource managed by the `parts` submodule.
  - `example_widgets_parts_components` - Override slot for the grandchild `components` submodule. Defaults live in that submodule.
    - `example_widgets_parts_components` - The component resource managed by the `components` submodule.
DESCRIPTION
}

# `type =` of every `azapi_resource` MUST come from `var.resource_types`,
# never a hard-coded string. The resource label (`this`) and the
# `resource_types` key (`example_widgets`) are independent concerns.
resource "azapi_resource" "this" {
  type      = var.resource_types.example_widgets
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  response_export_values = []
}

# Cascade the nested slot through to the submodule unchanged. The submodule's
# `resource_types` variable has exactly the shape of the slot, so no
# repacking or renaming is required.
module "part" {
  source         = "./modules/part"
  for_each       = var.parts
  name           = each.value.name
  parent_id      = azapi_resource.this.id
  resource_types = var.resource_types.example_widgets_parts
}

