variable "private_endpoints" {
  type = map(object({
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    lock = object({
      name = optional(string, null)
      kind = optional(string, "None")
    })
    tags                                    = optional(map(any), null)
    service                                 = string
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, null)
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_resource_ids = optional(set(string), [])
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      group_id           = optional(string, "vault")
      member_name        = optional(string, "vault")
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
