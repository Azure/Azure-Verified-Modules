
// ============== //
//   Parameters   //
// ============== //

import { privateEndpointMultiServiceType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointMultiServiceType[]?

// ============= //
//   Resources   //
// ============= //

module >singularMainResourceType<_privateEndpoints 'br/public:avm/res/network/private-endpoint:>version<' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}->singularMainResourceType<-PrivateEndpoint-${index}'
  scope: resourceGroup(
    split(privateEndpoint.?resourceGroupResourceId ?? privateEndpoint.?subnetResourceId, '/')[2],
    split(privateEndpoint.?resourceGroupResourceId ?? privateEndpoint.?subnetResourceId, '/')[4]
  )
  params: {
    // Variant 2: A default service cannot be assumed (i.e., for services that have more than one private endpoint type, like Storage Account)
    name: privateEndpoint.?name ?? 'pep-${last(split(>singularMainResourceType<.id, '/'))}-${privateEndpoint.service}-${index}'
    privateLinkServiceConnections: privateEndpoint.?isManualConnection != true ? [
      {
        name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(>singularMainResourceType<.id, '/'))}-${privateEndpoint.service}-${index}'
        properties: {
          privateLinkServiceId: >singularMainResourceType<.id
          groupIds: [
            privateEndpoint.service
          ]
        }
      }
    ] : null
    manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true ? [
      {
        name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(>singularMainResourceType<.id, '/'))}-${privateEndpoint.service}-${index}'
        properties: {
          privateLinkServiceId: >singularMainResourceType<.id
          groupIds: [
            privateEndpoint.service
          ]
          requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
        }
      }
    ] : null
    subnetResourceId: privateEndpoint.subnetResourceId
    enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

@description('The private endpoints of the resource.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, index) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: >singularMainResourceType<_privateEndpoints[index].outputs.name
    resourceId: >singularMainResourceType<_privateEndpoints[index].outputs.resourceId
    groupId: >singularMainResourceType<_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: >singularMainResourceType<_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: >singularMainResourceType<_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}
