privateEndpoints: {
  {
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
    customDnsConfigs: [ // this is an output in TF, check please
      {
        fqdn: 'fqdn1.example.com'
        ipAddresses: [
          '10.0.0.1',
          '10.0.0.2'
        ]
      }
    ]
    networkInterfaceName: 'nic1'
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
