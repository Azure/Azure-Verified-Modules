# The key URI follows a fixed pattern, so it is derived from the interface inputs
# rather than read back through data sources, which Terraform resolves during plan
# and which therefore fail when the key or identity is created by the same apply.
locals {
  cmk = var.customer_managed_key

  cmk_is_managed_hsm = local.cmk == null ? false : can(provider::azapi::parse_resource_id("Microsoft.KeyVault/managedHSMs", local.cmk.key_vault_resource_id))

  cmk_vault_name = try(provider::azapi::parse_resource_id(
    local.cmk_is_managed_hsm ? "Microsoft.KeyVault/managedHSMs" : "Microsoft.KeyVault/vaults",
    local.cmk.key_vault_resource_id
  ).name, null)

  cmk_derived_vault_uri = local.cmk_vault_name == null ? null : "https://${local.cmk_vault_name}.${local.cmk_is_managed_hsm ? "managedhsm.azure.net" : "vault.azure.net"}"

  cmk_vault_uri = local.cmk == null ? null : trimsuffix(coalesce(local.cmk.key_vault_uri, local.cmk_derived_vault_uri), "/")

  # A null `key_version` yields a versionless URI, which enables auto-rotation.
  cmk_key_uri = local.cmk == null ? null : format(
    "%s/keys/%s%s",
    local.cmk_vault_uri,
    local.cmk.key_name,
    local.cmk.key_version == null ? "" : "/${local.cmk.key_version}"
  )

  cmk_identity_client_id   = try(local.cmk.user_assigned_identity.client_id, null)
  cmk_identity_resource_id = try(local.cmk.user_assigned_identity.resource_id, null)
}

# `Microsoft.ContainerRegistry/registries` takes a single combined key identifier and
# identifies the encryption identity by client ID, and additionally requires that
# identity to be assigned to the registry.
resource "azapi_resource" "this" {
  type      = var.resource_types.containerregistry_registries
  name      = var.name
  location  = var.location
  parent_id = var.resource_group_resource_id

  body = {
    properties = {
      # ... other properties
      encryption = local.cmk == null ? null : {
        status = "enabled"
        keyVaultProperties = {
          keyIdentifier = local.cmk_key_uri
          identity      = local.cmk_identity_client_id
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = local.cmk == null || local.cmk_identity_client_id != null
      error_message = "`customer_managed_key.user_assigned_identity.client_id` must be supplied because the Container Registry API identifies the encryption identity by client ID."
    }
    precondition {
      condition     = local.cmk == null || local.cmk_identity_resource_id != null
      error_message = "`customer_managed_key.user_assigned_identity.resource_id` must be supplied so that the identity can be confirmed as assigned to the Container Registry."
    }
    precondition {
      condition     = local.cmk_identity_resource_id == null || contains(var.managed_identities.user_assigned_resource_ids, local.cmk_identity_resource_id)
      error_message = "The user assigned managed identity used for customer managed key encryption must also be assigned to the Container Registry via `managed_identities.user_assigned_resource_ids`."
    }
  }
}
