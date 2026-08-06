customer_managed_key = {
  # Omit the trailing version segment to let the resource provider follow key
  # rotations automatically. The host is supplied in full, so the same input shape
  # works in sovereign clouds and against Managed HSM, for example
  # `https://{managedHsmName}.managedhsm.azure.net/keys/{keyName}/{keyVersion}`.
  key_vault_key_uri = "https://{keyVaultName}.vault.azure.net/keys/{keyName}"

  user_assigned_identity_client_id = "{userAssignedIdentityClientId}"
}
