variable "customer_managed_key" {
  type = object({
    key_vault_resource_id = optional(string, null)
    key_vault_uri         = optional(string, null)
    key_name              = string
    key_version           = optional(string, null)
    user_assigned_identity = optional(object({
      resource_id = optional(string, null)
      client_id   = optional(string, null)
    }), null)
  })
  default = null

  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.key_vault_resource_id != null || var.customer_managed_key.key_vault_uri != null
    error_message = "`customer_managed_key` requires at least one of `key_vault_resource_id` or `key_vault_uri` to be set."
  }
  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.key_vault_resource_id == null || can(provider::azapi::parse_resource_id("Microsoft.KeyVault/vaults", var.customer_managed_key.key_vault_resource_id)) || can(provider::azapi::parse_resource_id("Microsoft.KeyVault/managedHSMs", var.customer_managed_key.key_vault_resource_id))
    error_message = "`customer_managed_key.key_vault_resource_id` must be a valid Azure Key Vault or Managed HSM resource ID."
  }
  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.key_vault_uri == null || can(regex("^https://[^/]+/?$", var.customer_managed_key.key_vault_uri))
    error_message = "`customer_managed_key.key_vault_uri` must be an HTTPS URI without a path, for example `https://{keyVaultName}.vault.usgovcloudapi.net`."
  }
  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.user_assigned_identity == null || var.customer_managed_key.user_assigned_identity.resource_id != null || var.customer_managed_key.user_assigned_identity.client_id != null
    error_message = "`customer_managed_key.user_assigned_identity` requires at least one of `resource_id` or `client_id` to be set."
  }
  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.user_assigned_identity == null || var.customer_managed_key.user_assigned_identity.resource_id == null || can(provider::azapi::parse_resource_id("Microsoft.ManagedIdentity/userAssignedIdentities", var.customer_managed_key.user_assigned_identity.resource_id))
    error_message = "`customer_managed_key.user_assigned_identity.resource_id` must be a valid user-assigned managed identity resource ID."
  }
  validation {
    condition     = var.customer_managed_key == null || var.customer_managed_key.user_assigned_identity == null || var.customer_managed_key.user_assigned_identity.client_id == null || can(regex("^[0-9a-fA-F]{8}-([0-9a-fA-F]{4}-){3}[0-9a-fA-F]{12}$", var.customer_managed_key.user_assigned_identity.client_id))
    error_message = "`customer_managed_key.user_assigned_identity.client_id` must be a valid GUID."
  }
}
