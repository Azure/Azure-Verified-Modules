variable "lock" {
  type = object({
    name = optional(string, null)
    kind = string
  })
  description = "The lock level to apply to the resource. Possible values are `CanNotDelete` and `ReadOnly`."
  default     = null
  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "The lock level must be one of: 'CanNotDelete', 'ReadOnly'."
  }
}

# Example resource implementation
resource "azurerm_management_lock" "this" {
  count      = var.lock != null ? 1 : 0
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = azurerm_MY_RESOURCE.this.id
  lock_level = var.lock.kind
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete resource or child resources." : "Cannot delete or modify the resource or child resources."
}