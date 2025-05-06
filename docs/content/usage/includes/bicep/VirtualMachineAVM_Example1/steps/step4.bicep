module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: 'VM-AVM-Ex1-LAW'
    // Non-required parameters
    location: 'westus2'
  }
}

module virtualNetwork 'br/public:avm/res/network/virtual-network:0.6.1' = {
  name: 'virtualNetworkDeployment'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    name: 'VM-AVM-Ex1-vnet'
    // Non-required parameters
    location: 'westus2'
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
        addressPrefix: cidrSubnet('10.0.0.0/16', 24, 0) // first subnet in address space
      }
      {
        name: 'VMSubnet'
        addressPrefix: cidrSubnet('10.0.0.0/16', 24, 1) // second subnet in address space
      }
    ]
  }
}
