module logAnalyticsWorkspace 'br/public:avm/res/operational-insights/workspace:0.11.1' = {
  name: 'logAnalyticsWorkspace'
  params: {
    // Required parameters
    name: 'VM-AVM-Ex1-law'
    // Non-required parameters
    location: 'westus2'
  }
}

module natGwPublicIp 'br/public:avm/res/network/public-ip-address:0.8.0' = {
  name: 'natGwPublicIpDeployment'
  params: {
    // Required parameters
    name: 'VM-AVM-Ex1-natgwpip'
    // Non-required parameters
    location: 'westus2'
    diagnosticSettings: [
      {
        name: 'natGwPublicIpDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
  }
}

module natGateway 'br/public:avm/res/network/nat-gateway:1.2.2' = {
  name: 'natGatewayDeployment'
  params: {
    // Required parameters
    name: 'VM-AVM-Ex1-natGw'
    zone: 1
    // Non-required parameters
    publicIpResourceIds: [
      natGwPublicIp.outputs.resourceId
    ]
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
        name: 'vNetDiagnostics'
        workspaceResourceId: logAnalyticsWorkspace.outputs.resourceId
      }
    ]
    subnets: [
      {
        name: 'VMSubnet'
        addressPrefix: cidrSubnet('10.0.0.0/16', 24, 0) // first subnet in address space
        natGatewayResourceId: natGateway.outputs.resourceId
      }
    ]
  }
}
