# The vault is read by resource ID, not by name. That is safe in both directions: when
# the vault already exists the read resolves during plan, and when the vault is created
# by the same apply its resource ID is unknown at plan time, so Terraform defers the
# read. Reading the *key* the same way is not safe, which is what Variant 2 exists for.
data "azapi_resource" "customer_managed_key_vault" {
  count = var.customer_managed_key == null ? 0 : 1

  type                   = var.resource_types.keyvault_vaults
  resource_id            = var.customer_managed_key.key_vault_resource_id
  response_export_values = ["properties.vaultUri"]
}

locals {
  customer_managed_key_vault_uri = try(
    data.azapi_resource.customer_managed_key_vault[0].output.properties.vaultUri,
    null
  )

  customer_managed_key_identity_resource_id = try(
    var.customer_managed_key.user_assigned_identity.resource_id,
    null
  )
}

# `Microsoft.Storage/storageAccounts` takes the vault URI, key name and key version as
# separate fields, and identifies the encryption identity by resource ID. A null
# `keyversion` leaves the account following key rotations automatically.
resource "azapi_resource" "this" {
  type      = var.resource_types.storage_storage_accounts
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_resource_id

  body = {
    properties = {
      # ... other properties
      encryption = var.customer_managed_key == null ? null : {
        keySource = "Microsoft.Keyvault"
        identity = {
          userAssignedIdentity = local.customer_managed_key_identity_resource_id
        }
        keyvaultproperties = {
          keyvaulturi = local.customer_managed_key_vault_uri
          keyname     = var.customer_managed_key.key_name
          keyversion  = var.customer_managed_key.key_version
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = var.customer_managed_key == null || local.customer_managed_key_identity_resource_id != null
      error_message = "`customer_managed_key.user_assigned_identity.resource_id` must be supplied because the Storage API identifies the encryption identity by resource ID."
    }
    precondition {
      condition     = local.customer_managed_key_identity_resource_id == null || contains(var.managed_identities.user_assigned_resource_ids, local.customer_managed_key_identity_resource_id)
      error_message = "The user assigned managed identity used for customer managed key encryption must also be assigned to the Storage Account via `managed_identities.user_assigned_resource_ids`."
    }
  }
}
