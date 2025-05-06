param location string = 'westus2'

var addressPrefix = '10.0.0.0/16'
var prefix = 'VM-AVM-Ex1'

module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: '${prefix}-LAW'
    // Non-required parameters
    location: location
  }
}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'virtualNetworkDeployment'
  params: {
    // Required parameters
    addressPrefixes: [
      addressPrefix
    ]
    name: '${prefix}-vnet'
    // Non-required parameters
    location: location
    diagnosticSettings: [
      {
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'vNetDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    subnets: [
      {
        name: 'AzureBastionSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 0) // first subnet in address space
      }
      {
        name: 'VMSubnet'
        addressPrefix: cidrSubnet(addressPrefix, 24, 1) // second subnet in address space
      }
    ]
  }
}
