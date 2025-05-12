module "avm-res-compute-virtualmachine" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.19.1"

  enable_telemetry    = true
  location            = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name = module.avm-res-resources-resourcegroup.name
  name                = "${var.name_prefix}-vm"
  os_type             = "Linux"
  sku_size            = "Standard_D2s_v5"
  zone                = 1

  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  network_interfaces = {
    network_interface_1 = {
      name = "${var.name_prefix}-nic-${random_string.name_suffix.result}"
      ip_configurations = {
        ip_configuration_1 = {
          name                          = "${var.name_prefix}-ipconfig-${random_string.name_suffix.result}"
          private_ip_subnet_resource_id = module.avm-res-network-virtualnetwork.subnets["subnet0"].resource_id
        }
      }
    }
  }

  diagnostic_settings = {
    sendToLogAnalytics = {
      name                           = "${var.name_prefix}-vm-diagnostic"
      workspace_resource_id          = module.avm-res-operationalinsights-workspace.resource_id
      log_analytics_destination_type = "Dedicated"
    }
  }
}
