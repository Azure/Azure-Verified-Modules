
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
  scope: !empty(privateEndpoint.?resourceGroupResourceId)
  ? resourceGroup(
      split((privateEndpoint.?resourceGroupResourceId ?? '//'), '/')[2],
      split((privateEndpoint.?resourceGroupResourceId ?? '////'), '/')[4]
    )
  : resourceGroup(
      split((privateEndpoint.?subnetResourceId ?? '//'), '/')[2],
      split((privateEndpoint.?subnetResourceId ?? '////'), '/')[4]
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
