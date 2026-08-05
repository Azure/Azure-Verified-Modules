# The key URI follows a fixed pattern, so it is derived from the interface inputs
# rather than read back through data sources, which Terraform resolves during plan
# and which therefore fail when the key or identity is created by the same apply.
locals {
  # `can` is false both when the resource ID belongs to a vault rather than a Managed
  # HSM, and when no resource ID has been supplied.
  customer_managed_key_is_managed_hsm = can(provider::azapi::parse_resource_id(
    "Microsoft.KeyVault/managedHSMs",
    var.customer_managed_key.key_vault_resource_id
  ))

  customer_managed_key_vault_name = try(provider::azapi::parse_resource_id(
    local.customer_managed_key_is_managed_hsm ? "Microsoft.KeyVault/managedHSMs" : "Microsoft.KeyVault/vaults",
    var.customer_managed_key.key_vault_resource_id
  ).name, null)

  customer_managed_key_vault_dns_suffix = local.customer_managed_key_is_managed_hsm ? "managedhsm.azure.net" : "vault.azure.net"

  customer_managed_key_derived_vault_uri = local.customer_managed_key_vault_name == null ? null : "https://${local.customer_managed_key_vault_name}.${local.customer_managed_key_vault_dns_suffix}"

  customer_managed_key_vault_uri = var.customer_managed_key == null ? null : trimsuffix(coalesce(
    var.customer_managed_key.key_vault_uri,
    local.customer_managed_key_derived_vault_uri
  ), "/")

  # A null `key_version` yields a versionless URI, which enables auto-rotation.
  customer_managed_key_uri = var.customer_managed_key == null ? null : format(
    "%s/keys/%s%s",
    local.customer_managed_key_vault_uri,
    var.customer_managed_key.key_name,
    var.customer_managed_key.key_version == null ? "" : "/${var.customer_managed_key.key_version}"
  )

  customer_managed_key_identity_client_id   = try(var.customer_managed_key.user_assigned_identity.client_id, null)
  customer_managed_key_identity_resource_id = try(var.customer_managed_key.user_assigned_identity.resource_id, null)
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
      encryption = var.customer_managed_key == null ? null : {
        status = "enabled"
        keyVaultProperties = {
          keyIdentifier = local.customer_managed_key_uri
          identity      = local.customer_managed_key_identity_client_id
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = var.customer_managed_key == null || local.customer_managed_key_identity_client_id != null
      error_message = "`customer_managed_key.user_assigned_identity.client_id` must be supplied because the Container Registry API identifies the encryption identity by client ID."
    }
    precondition {
      condition     = var.customer_managed_key == null || local.customer_managed_key_identity_resource_id != null
      error_message = "`customer_managed_key.user_assigned_identity.resource_id` must be supplied so that the identity can be confirmed as assigned to the Container Registry."
    }
    precondition {
      condition     = local.customer_managed_key_identity_resource_id == null || contains(var.managed_identities.user_assigned_resource_ids, local.customer_managed_key_identity_resource_id)
      error_message = "The user assigned managed identity used for customer managed key encryption must also be assigned to the Container Registry via `managed_identities.user_assigned_resource_ids`."
    }
  }
}
