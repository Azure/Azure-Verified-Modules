@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('The current released version of the module. Used for telemetry.')
var moduleVersion = '[[moduleVersion]]' // for example '1.0.0'

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
  name: take('46d3xbcp.res.compute-virtualmachine.${replace(moduleVersion, '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}', 64)
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}
