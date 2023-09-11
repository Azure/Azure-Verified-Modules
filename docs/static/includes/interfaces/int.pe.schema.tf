variable "private_endpoints" {
  type = map(object({
    diagnostic_settings                     = map(object({}))        # see https://azure.github.io/Azure-Verified-Modules/Azure-Verified-Modules/specs/shared/interfaces/#diagnostic-settings
    role_assignments                        = map(object({}))        # see https://azure.github.io/Azure-Verified-Modules/Azure-Verified-Modules/specs/shared/interfaces/#role-assignments
    lock                                    = object({})             # see https://azure.github.io/Azure-Verified-Modules/Azure-Verified-Modules/specs/shared/interfaces/#resource-locks
    tags                                    = optional(map(any), {}) # see https://azure.github.io/Azure-Verified-Modules/Azure-Verified-Modules/specs/shared/interfaces/#tags
    service                                 = string
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, null)
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_resource_ids = optional(set(string), [])
    network_interface_name                  = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      group_id           = optional(string, null)
      member_name        = optional(string, null)
      private_ip_address = string
    })), {})
  }))
  default = {}
}

# Be sure to export the custom dns configs for the private endpoints you create.
# Replace the resource symbolic name (azurerm_private_endpoint.this) with your own.
output "custom_dns_configs" {
  value = var.private_endpoints == {} ? {} : {
    for k, v in var.private_endpoints : k => azurerm_private_endpoint.this[k].custom_dns_configs
  }
  description = <<DESCRIPTION
A map of the private endpoints created, using the key from var.private_endpoints.
Value is an object containing the fqdn and list of ip_addresses.
DESCRIPTION
}
