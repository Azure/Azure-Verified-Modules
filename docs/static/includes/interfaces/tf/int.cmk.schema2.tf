variable "customer_managed_key" {
  type = object({
    key_vault_key_uri                = string
    user_assigned_identity_client_id = optional(string, null)
  })
  default = null

  validation {
    condition     = var.customer_managed_key == null || can(regex("^https://[^/]+/keys/[^/]+(/[^/]+)?$", var.customer_managed_key.key_vault_key_uri))
    error_message = "`customer_managed_key.key_vault_key_uri` must be a Key Vault or Managed HSM key URI, in the form `https://{vaultHost}/keys/{keyName}` or `https://{vaultHost}/keys/{keyName}/{keyVersion}`."
  }
  validation {
    condition     = try(var.customer_managed_key.user_assigned_identity_client_id, null) == null || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.customer_managed_key.user_assigned_identity_client_id))
    error_message = "`customer_managed_key.user_assigned_identity_client_id` must be a valid GUID."
  }
}
