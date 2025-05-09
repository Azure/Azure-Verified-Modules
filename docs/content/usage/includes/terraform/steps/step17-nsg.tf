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
