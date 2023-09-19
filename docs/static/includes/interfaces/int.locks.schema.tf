variable "lock" {
  type = object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
  default = {}

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly", "None"], var.lock.type)
    error_message = "Lock type must be one of: CanNotDelete, ReadOnly, None."
  }
}

# Example declaration of the resource

resource "azurerm_management_lock" "this" {
  count      = var.lock.kind != "None" ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = # Your resource ID here
  lock_level = var.lock.kind
}
