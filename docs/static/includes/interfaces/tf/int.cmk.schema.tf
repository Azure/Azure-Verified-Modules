variable "customer_managed_key" {
  type = object({
    key_vault_resource_id  = string
    key_name               = string
    key_version            = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = string
    }), null)
  })
  default = null

  validation {
    condition     = var.customer_managed_key == null || can(provider::azapi::parse_resource_id("Microsoft.KeyVault/vaults", var.customer_managed_key.key_vault_resource_id))
    error_message = "`customer_managed_key.key_vault_resource_id` must be a valid Azure Key Vault resource ID."
  }
  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.user_assigned_identity == null || can(provider::azapi::parse_resource_id("Microsoft.ManagedIdentity/userAssignedIdentities", var.customer_managed_key.user_assigned_identity.resource_id))
    error_message = "`customer_managed_key.user_assigned_identity.resource_id` must be a valid user-assigned managed identity resource ID."
  }
}
