privateEndpoints: {
  {
    diagnosticSettings: [...]
    roleAssignments : [...]
    lock: 'CanNotDelete'
    tags: {...}
    service: 'vault'
    subnetResourceId: '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{vnetName}/subnets/{subnetName}'
    privateDnsZoneResourceIds: [
      '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{dnsZoneName}'
    ]
    applicationSecurityGroupResourceIds: [
      '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/applicationSecurityGroups/{asgName}'
    ]
    customDnsConfigs: [
      {
        fqdn: 'fqdn1.example.com'
        ipAddresses: [
          '10.0.0.1',
          '10.0.0.2'
        ]
      }
    ]
    customNetworkInterfaceName: 'nic1'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        groupId: 'vault'
        memberName: 'default'
        privateIpAddress: '10.0.0.7'
      }
    ]
  }
}
