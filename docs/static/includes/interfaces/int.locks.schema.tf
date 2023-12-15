variable "lock" {
  type = object({
    name = optional(string, null)
    kind = string
  })
  description = <<-EOT
Applies a lock to the resource. The following properties can be specified:
- name - (Optional) The name of the lock. Changing this forces a new resource to be created.
- kind - (Required) The type of lock. Possible values are `CanNotDelete` and `ReadOnly`.
EOT
  default     = null
  validation {
    condition     = var.lock == null || contains(["CanNotDelete", "ReadOnly"], try(var.lock.kind, ""))
    error_message = "The lock level must be one of: 'CanNotDelete', 'ReadOnly'."
  }
}

# Example resource implementation
resource "azurerm_management_lock" "this" {
  count      = var.lock != null ? 1 : 0

  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_kubernetes_cluster.main.id
  lock_level = var.lock.kind
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete resource or child resources." : "Cannot delete or modify the resource or child resources."
}
