@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Disable usage telemetry for module.')
param disableTelemetry bool = false

@description('The current released version of the module. Used for telemetry.')
var moduleVersion = 'v1.0.0'

resource avmTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (!disableTelemetry) {
  name: '46d3xgp5.res.compute-virtualmachine.${replace(moduleVersion, '.', '-')}.${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}
