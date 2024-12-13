
// ============== //
//   Parameters   //
// ============== //

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

// ============= //
//   Resources   //
// ============= //

module >singularMainResourceType<_privateEndpoints 'br/public:avm/res/network/private-endpoint:>version<' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}->singularMainResourceType<-PrivateEndpoint-${index}'
  scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
  params: {
    // Variant 1: A default service can be assumed (i.e., for services that only have one private endpoint type)
    name: privateEndpoint.?name ?? 'pep-${last(split(>singularMainResourceType<.id, '/'))}-${privateEndpoint.?service ?? '>defaultServiceName<'}-${index}'
    privateLinkServiceConnections: privateEndpoint.?isManualConnection != true ? [
      {
        name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(>singularMainResourceType<.id, '/'))}-${privateEndpoint.?service ?? '>defaultServiceName<'}-${index}'
        properties: {
          privateLinkServiceId: >singularMainResourceType<.id
          groupIds: [
            privateEndpoint.?service ?? '>defaultServiceName<'
          ]
        }
      }
    ] : null
    manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true ? [
      {
        name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(>singularMainResourceType<.id, '/'))}-${privateEndpoint.?service ?? '>defaultServiceName<'}-${index}'
        properties: {
          privateLinkServiceId: >singularMainResourceType<.id
          groupIds: [
            privateEndpoint.?service ?? '>defaultServiceName<'
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
