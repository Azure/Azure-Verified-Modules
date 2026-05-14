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

module "avm_interfaces" {
  source  = "Azure/avm-utl-interfaces/azure"
  version = "0.6.0" # check latest version at the time of use

  managed_identities = var.managed_identities
}

# Example identity block on the parent azapi_resource. The avm_interfaces
# module returns a single object with the correct `type` and `identity_ids`
# values, including the case when no identity is configured (in which case
# the for_each is empty and no identity block is rendered).
#
# Note: AzAPI accepts a single `identity` block. The dynamic block below
# renders zero or one block depending on whether a managed identity is
# configured. The same pattern works for resources that only support
# SystemAssigned or only UserAssigned identities.
resource "azapi_resource" "this" {
  # ...other arguments...

  dynamic "identity" {
    for_each = module.avm_interfaces.managed_identities_azapi != null ? [module.avm_interfaces.managed_identities_azapi] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
}
