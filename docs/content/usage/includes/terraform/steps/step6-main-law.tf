module "avm-res-operationalinsights-workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"

  enable_telemetry                          = true
  location                                  = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name                       = module.avm-res-resources-resourcegroup.name
  name                                      = "${var.name_prefix}-law"
  log_analytics_workspace_retention_in_days = 30
  log_analytics_workspace_sku               = "PerGB2018"
}
