module "avm-res-keyvault-vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.0"

  enable_telemetry    = true
  location            = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name = module.avm-res-resources-resourcegroup.name
  name                = "${var.name_prefix}-kv-${random_string.suffix.result}"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  role_assignments = {
    deployment_user_kv_admin = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.this.object_id
    }
  }
}
