module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: 'VM-AVM-Ex1-law'
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
  }
}
