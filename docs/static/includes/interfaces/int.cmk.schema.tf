variable "customer_managed_key" {
  type = object({
    key_vault_resource_id              = string
    key_name                           = string
    key_version                        = optional(string, null)
    user_assigned_identity_resource_id = optional(string, null)
  })
  default = {}
}
