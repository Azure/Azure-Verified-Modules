# Variant 2 carries exactly the two values the API consumes, so the module performs no
# resolution at all: no data sources, no URI construction, and no cloud specific DNS
# suffix handling. The consumer builds the key URI from the key resource they own, and
# supplies the client ID of the identity that the registry uses to reach the vault.
#
# `Microsoft.ContainerRegistry/registries` takes a single combined key identifier and
# identifies the encryption identity by client ID. A client ID cannot be derived from an
# identity resource ID without a data source, which is why this variant exists.
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
          keyIdentifier = var.customer_managed_key.key_vault_key_uri
          identity      = var.customer_managed_key.user_assigned_identity == null ? null : var.customer_managed_key.user_assigned_identity.client_id
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = var.customer_managed_key == null || var.customer_managed_key.user_assigned_identity != null
      error_message = "`customer_managed_key.user_assigned_identity` must be supplied because the Container Registry API identifies the encryption identity by client ID."
    }
  }
}
