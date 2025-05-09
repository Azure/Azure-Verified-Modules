module "avm-res-keyvault-vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.0"

  enable_telemetry    = true
  location            = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name = module.avm-res-resources-resourcegroup.name
  name                = "${var.name_prefix}-kv-${random_string.name_suffix.result}"
  tenant_id           = data.azurerm_client_config.this.tenant_id
  network_acls        = null

  diagnostic_settings = {
    to_la = {
      name                  = "${var.name_prefix}-kv-diags"
      workspace_resource_id = module.avm-res-operationalinsights-workspace.resource_id
    }
  }

  role_assignments = {
    deployment_user_kv_admin = {
      role_definition_id_or_name = "Key Vault Administrator"
      principal_id               = data.azurerm_client_config.this.object_id
    }
  }
}
