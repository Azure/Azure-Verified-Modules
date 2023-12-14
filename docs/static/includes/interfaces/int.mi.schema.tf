variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default = {}
}

# Example resource implementation
dynamic "identity" {
  for_each = var.managed_identities != null && (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? [var.managed_identities] : []
  content {
    type         = (each.value.system_assigned && length(identity.value.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(identity.value.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned")
    identity_ids = identity.value.user_assigned_resource_ids
  }
}
