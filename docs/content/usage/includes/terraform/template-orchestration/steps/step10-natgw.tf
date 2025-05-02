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
