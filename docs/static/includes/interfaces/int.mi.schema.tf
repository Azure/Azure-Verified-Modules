variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
  nullable    = false
}

# Example resource implementation

## Resources supporting both SystemAssigned and UserAssigned
  dynamic "identity" {
    for_each = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? { this = var.managed_identities } : {}
    content {
      type         = identity.value.system_assigned && length(identity.value.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(identity.value.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }

## Resources that only supports SystemAssigned
  dynamic "identity" {
    for_each = var.managed_identities.system_assigned ? { this = var.managed_identities } : {}
    content {
      type = "SystemAssigned"
    }
  }

## Resources that only supports UserAssigned
  dynamic "identity" {
    for_each = length(var.managed_identities.user_assigned_resource_ids) > 0 ? { this = var.managed_identities } : {}
    content {
      type         = "UserAssigned"
      identity_ids = identity.value.user_assigned_resource_ids
    }
  }
