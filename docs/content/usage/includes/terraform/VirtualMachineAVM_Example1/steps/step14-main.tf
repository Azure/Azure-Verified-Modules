module "avm-res-resources-resourcegroup" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  name = "${var.name_prefix}-rg"
  location = var.location
  tags = var.tags
}

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

data "azurerm_client_config" "this" {}

resource "random_string" "name_suffix" {
  length  = 4
  special = false
  upper   = false
}

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

module "avm-res-network-natgateway" {
  source  = "Azure/avm-res-network-natgateway/azurerm"
  version = "0.2.1"

  name                = "${var.name_prefix}-natgw"
  enable_telemetry    = true
  location            = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name = module.avm-res-resources-resourcegroup.name

  public_ips = {
    public_ip_1 = {
      name = "${var.name_prefix}-natgw-pip"
    }
  }
}

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

module "avm-res-network-networksecuritygroup" {
  source  = "Azure/avm-res-network-networksecuritygroup/azurerm"
  version = "0.4.0"
  resource_group_name = module.avm-res-resources-resourcegroup.name
  name                = "${var.name_prefix}-vm-subnet-nsg"
  location            = module.avm-res-resources-resourcegroup.resource.location

  security_rules = {
    "rule01" = {
      name                       = "${var.name_prefix}-ssh"
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_ranges    = ["22"]
      direction                  = "Inbound"
      priority                   = 200
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }
}

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
