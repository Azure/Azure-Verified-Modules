module "avm-res-network-bastionhost" {
  source  = "Azure/avm-res-network-bastionhost/azurerm"
  version = "0.7.2"

  name                = "${var.name_prefix}-bastion"
  resource_group_name = module.avm-res-resources-resourcegroup.name
  location            = module.avm-res-resources-resourcegroup.resource.location
  ip_configuration = {
    subnet_id = module.avm-res-network-virtualnetwork.subnets["bastion"].resource_id
  }

  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = "${var.name_prefix}-bastion-diagnostic"
      workspace_resource_id          = module.avm-res-operationalinsights-workspace.resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }
}
