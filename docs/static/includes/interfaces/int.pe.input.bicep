privateEndpoints: {
  {
    name: 'myPeName'
    privateLinkServiceConnectionName: 'myPrivateLinkConnectionName'
    lock: 'CanNotDelete'
    tags: {
      'hidden-title': 'This is visible in the resource name'
    }
    service: 'vault'
    subnetResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/virtualNetworks/myVnet/subnets/mysubnet'
    privateDnsZoneResourceIds: [
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/privateDnsZones/myZone'
    ]
    applicationSecurityGroupResourceIds: [
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRg/providers/Microsoft.Network/applicationSecurityGroups/myAsg'
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
    networkInterfaceName: 'nic1'
    ipConfigurations: [
      {
        name: 'ipconfig1'
        groupId: 'vault'
        memberName: 'default'
        privateIpAddress: '10.0.0.7'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Owner'
        principalId: '11111111-1111-1111-1111-111111111111'
        principalType: 'ServicePrincipal'
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions','acdd72a7-3385-48ef-bd42-f606fba81ae7')
        principalId: '11111111-1111-1111-1111-111111111111'
        principalType: 'ServicePrincipal'
      }
    ]
    resourceGroupName: 'mySecondaryRg'
  }
}
