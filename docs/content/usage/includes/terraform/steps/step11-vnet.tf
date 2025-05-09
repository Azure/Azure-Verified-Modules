module "avm-res-network-virtualnetwork" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.8.1"

  resource_group_name = module.avm-res-resources-resourcegroup.name
  location            = module.avm-res-resources-resourcegroup.resource.location
  name                = "${var.name_prefix}-vnet"

  address_space = [var.virtual_network_cidr]

  subnets = {
    subnet0 = {
      name                            = "${var.name_prefix}-vm-subnet"
      default_outbound_access_enabled = false
      address_prefixes = [cidrsubnet(var.virtual_network_cidr, 1, 0)]
      nat_gateway = {
        id = module.avm-res-network-natgateway.resource_id
      }
      network_security_group = {
        id = module.avm-res-network-networksecuritygroup.resource_id
      }
    }
    bastion = {
      name                            = "AzureBastionSubnet"
      default_outbound_access_enabled = false
      address_prefixes = [cidrsubnet(var.virtual_network_cidr, 1, 1)]
    }
  }

  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = "${var.name_prefix}-vnet-diagnostic"
      workspace_resource_id          = module.avm-res-operationalinsights-workspace.resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }
}
