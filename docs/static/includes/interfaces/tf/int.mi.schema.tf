variable "managed_identities" {
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
Controls the Managed Identity configuration on this resource. The following properties can be specified:

- `system_assigned` - (Optional) Specifies if the System Assigned Managed Identity should be enabled.
- `user_assigned_resource_ids` - (Optional) Specifies a list of User Assigned Managed Identity resource IDs to be assigned to this resource.
DESCRIPTION
}

# Helper locals to make the dynamic block more readable
# There are three attributes here to cater for resources that
# support both user and system MIs, only system MIs, and only user MIs
locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
}

## Resources supporting both SystemAssigned and UserAssigned
dynamic "identity" {
  for_each = local.managed_identities.system_assigned_user_assigned
  content {
    type         = identity.value.type
    identity_ids = identity.value.user_assigned_resource_ids
  }
}

## Resources that only support SystemAssigned
dynamic "identity" {
  for_each = identity.managed_identities.system_assigned
  content {
    type = identity.value.type
  }
}

## Resources that only support UserAssigned
dynamic "identity" {
  for_each = local.managed_identities.user_assigned
  content {
    type         = identity.value.type
    identity_ids = identity.value.user_assigned_resource_ids
  }
}
