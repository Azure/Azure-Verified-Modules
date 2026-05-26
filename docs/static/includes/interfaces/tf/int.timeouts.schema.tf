variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Default per-operation timeouts applied to every `azapi` resource managed by the module. Defaults to `null` (provider defaults). Each value is a Go duration string (e.g. `30m`, `1h`).

- `create` - (Optional) Timeout for create operations.
- `read`   - (Optional) Timeout for read operations.
- `update` - (Optional) Timeout for update operations.
- `delete` - (Optional) Timeout for delete operations.
DESCRIPTION
}

# Example resource implementation. `timeouts` is a block on `azapi_resource`,
# so a `dynamic "timeouts"` block is required to honour the variable's `null`
# default. The same pattern applies to every `azapi_resource` declared by
# the module, including those in submodules.
resource "azapi_resource" "this" {
  type      = var.resource_types.this
  name      = var.name
  parent_id = var.parent_id
  body      = { /* ... */ }

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

# Cascade `timeouts` to every submodule the parent module instantiates so that
# a single override at the parent level propagates everywhere.
module "child" {
  source = "./modules/child"

  timeouts = var.timeouts

  # ...other arguments...
}
