# The module resolves nothing through data sources, so every value may be an
# unresolved reference to a resource created by the same apply.
customer_managed_key = {
  key_vault_resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.KeyVault/vaults/{keyVaultName}"
  key_name              = "{keyName}"
  key_version           = "{keyVersion}"
  user_assigned_identity = {
    resource_id = "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{uamiName}"
    client_id   = "{uamiClientId}"
  }
}

# Alternatively, supply the vault URI directly instead of the vault resource ID. This
# is required in sovereign clouds, where the DNS suffix cannot be derived.
#
# customer_managed_key = {
#   key_vault_uri = "https://{keyVaultName}.vault.usgovcloudapi.net"
#   key_name      = "{keyName}"
#   user_assigned_identity = {
#     client_id = "{uamiClientId}"
#   }
# }
