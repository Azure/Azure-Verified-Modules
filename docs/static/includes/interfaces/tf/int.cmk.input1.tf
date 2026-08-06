customer_managed_key = {
  key_vault_resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}"
  key_name              = "{keyName}"

  # Omit `key_version` to let the resource provider follow key rotations automatically.
  key_version = "{keyVersion}"

  user_assigned_identity = {
    resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{userAssignedIdentityName}"
  }
}
