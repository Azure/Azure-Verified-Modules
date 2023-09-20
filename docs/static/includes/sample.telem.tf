locals {
  # This is the unique id for the module that is supplied by the AVM team.
  # TODO: change this to the PUID for the module. See https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry
  telem_puid = "46d3xgtf"

  # TODO: change this to the name of the module. See https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-sfr3---category-telemetry---deploymentusage-telemetry
  module_name = "CHANGEME"

  # Should be either `res` or `ptn`
  module_type = "res"

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
      "value": "For more information, see https://aka.ms/avm/TelemetryInfo"
    }
  }
}
TEMPLATE

  # This constructs the ARM deployment name that is used for the telemetry.
  # We shouldn't ever hit the 64 character limit but use substr just in case.
  telem_arm_deployment_name = substr(
    format(
      "%s.%s.%s.v%s.%s",
      local.telem_puid,
      local.module_type,
      substr(local.module_name, 0, 30),
      replace(local.module_version, ".", "-"),
      local.telem_random_hex
    ),
    0,
    64
  )
  telem_random_hex = can(random_id.telem[0].hex) ? random_id.telem[0].hex : ""
}

resource "random_id" "telemetry" {
  count       = local.enable_telemetry ? 1 : 0
  byte_length = 4
}

# This is the module telemetry deployment that is only created if telemetry is enabled.
# It is deployed to the resource's resource group.
resource "azurerm_resource_group_template_deployment" "telemetry" {
  count               = var.enable_telemetry ? 1 : 0
  name                = local.telem_arm_deployment_name
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  location            = var.location
  template_content    = local.telem_arm_template_content
}
