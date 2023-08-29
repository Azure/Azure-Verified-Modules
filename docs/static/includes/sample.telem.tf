locals {
  # This is an empty ARM deployment template.
  telem_arm_template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {},
  "variables": {},
  "resources": [],
  "outputs": {
    "telemetry": {
      "type": "String",
      "value": "For more information, see https://aka.ms/avm/telemetry"
    }
  }
}
TEMPLATE

  # This is the unique id for the module that is supplied by the AVM team.
  telem_puid = "00000000"

  # This constructs the ARM deployment name that is used for the telemetry.
  # We shouldn't ever hit the 64 character limit but use substr just in case.
  telem_arm_deployment_name = substr(
    format(
      "pid-%s_%s",
      local.telem_puid,
      local.module_version,
    ),
    0,
    64
  )
}

# This is the module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the resource's resource group.
resource "azurerm_resource_group_template_deployment" "telemetry" {
  count               = var.enable_telemetry ? 1 : 0
  name                = local.telem_arm_deployment_name
  resource_group_name = var.resource_group_name
  location            = var.location
  template_content    = local.telem_arm_template_content
}
