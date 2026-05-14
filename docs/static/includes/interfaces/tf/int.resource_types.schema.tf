# The `resource_types` variable is module-specific: the field set below is
# illustrative. Each module **MUST** declare one `optional(string, "...")`
# field per `azapi_resource` (or equivalent AzAPI resource) it declares,
# defaulting each field to the latest tested API version. Submodules
# **MUST** follow the same pattern for the resources they own. The field
# names **MUST** describe the resource being managed - never use generic
# names like `this` or `resource`.
variable "resource_types" {
  type = object({
    widget          = optional(string, "Microsoft.Example/widgets@2024-01-01")
    widget_setting  = optional(string, "Microsoft.Example/widgets/settings@2024-01-01")
    lock            = optional(string, "Microsoft.Authorization/locks@2020-05-01")
  })
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
Override the AzAPI `<provider>/<resource>@<api-version>` strings used by this module. Each key defaults to a tested value; supply only the keys you want to override. Useful when targeting a sovereign cloud with older API versions, or when opting into a newer preview API.

The keys below are specific to this example module (which manages widgets). Each module names its keys after the resources it actually owns - for example, a Cosmos DB module would expose keys such as `database_account`, `sql_database`, and `sql_container`.

- `widget`         - The primary widget managed by this module.
- `widget_setting` - Settings attached to the widget.
- `lock`           - Management lock applied to the widget and its private endpoints.
DESCRIPTION
}

# Example resource implementation. The `type` of every `azapi_resource`
# **MUST** come from `var.resource_types`, never a hard-coded string.
resource "azapi_resource" "widget" {
  type      = var.resource_types.widget
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

  response_export_values = []
}

# Cascade the relevant subset of `resource_types` to every submodule the
# parent module instantiates so that a single override at the parent level
# propagates to every resource the module manages. The submodule names its
# primary resource `setting` (because that is what it manages), while this
# parent module exposes the same resource as `widget_setting`.
module "setting" {
  source = "./modules/widget-setting"

  resource_types = {
    setting = var.resource_types.widget_setting
  }

  # ...other arguments...
}
