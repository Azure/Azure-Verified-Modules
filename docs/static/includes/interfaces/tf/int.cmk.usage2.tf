# The same locals feed a resource provider that takes the vault URI, key name and key
# version as separate fields, and that identifies the encryption identity by resource
# ID rather than client ID. `cmk_vault_uri` and `cmk_key_uri` are both exposed so that
# either shape can be satisfied without a data source.
resource "azapi_resource" "this" {
  type      = var.resource_types.storage_storage_accounts
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_resource_id

  body = {
    properties = {
      # ... other properties
      encryption = local.cmk == null ? null : {
        keySource = "Microsoft.Keyvault"
        identity = {
          userAssignedIdentity = local.cmk_identity_resource_id
        }
        keyvaultproperties = {
          keyvaulturi = local.cmk_vault_uri
          keyname     = local.cmk.key_name
          keyversion  = local.cmk.key_version
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = local.cmk == null || local.cmk_identity_resource_id != null
      error_message = "`customer_managed_key.user_assigned_identity.resource_id` must be supplied because the Storage API identifies the encryption identity by resource ID."
    }
    precondition {
      condition     = local.cmk_identity_resource_id == null || contains(var.managed_identities.user_assigned_resource_ids, local.cmk_identity_resource_id)
      error_message = "The user assigned managed identity used for customer managed key encryption must also be assigned to the Storage Account via `managed_identities.user_assigned_resource_ids`."
    }
  }
}
