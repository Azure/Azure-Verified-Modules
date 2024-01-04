variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = {
    kind = null
  }
  description = <<DESCRIPTION
Controls the Resource Lock configuration on this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `null`, `CanNotDelete` or `ReadOnly`.
- `name` - (Optional) The name of the lock. If not specified a name will be generated based on the `kind` value. Changing this forces a new resource to be created.
DESCRIPTION
  nullable    = false

  validation {
    condition     = var.lock.kind != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: `null`, `CanNotDelete` or `ReadOnly`."
  }
}

# Example resource implementation
resource "azurerm_management_lock" "this" {
  count = var.lock.kind != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_MY_RESOURCE.this.id
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete resource or child resources." : "Cannot delete or modify the resource or child resources."
}
