module "avm-res-resources-resourcegroup" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.2.1"

  name = "${var.name_prefix}-rg"
  location = var.location
  tags = var.tags
}
