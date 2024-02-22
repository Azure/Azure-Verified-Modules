variable "customer_managed_key" {
  type = object({
    key_vault_resource_id              = string
    key_name                           = string
    key_version                        = optional(string, null)
    user_assigned_identity_resource_id = optional(string, null)
  })
  default = null
  description = <<-DESCRIPTION
    The customer managed key (CMK) to use for encryption.

    - `key_vault_resource_id` - (Required) The resource ID of the Key Vault.
    - `key_name` - (Required) The name of the key in the Key Vault.
    - `key_version` - (Optional) The version of the key in the Key Vault.
    - `user_assigned_identity_resource_id` - (Optional) The resource ID of the user-assigned managed identity to use for accessing the key vault.
  DESCRIPTION
}
