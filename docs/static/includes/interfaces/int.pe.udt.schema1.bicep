type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  // Variant 1: A default service can be assumed (i.e., for services that only have one private endpoint type)
  @description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
}[]?

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

module >singularMainResourceType<_privateEndpoints 'br/public:avm/res/network/private-endpoint:X.Y.Z' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
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
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]
