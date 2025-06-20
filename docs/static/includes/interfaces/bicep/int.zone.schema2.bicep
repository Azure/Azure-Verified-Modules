// ============== //
//   Parameters   //
// ============== //

@description('Optional. The list of Availability zones to use for the zone-redundant resources.')
@allowed([
  1
  2
  3
])
param availabilityZones int[] = [1, 2, 3]

// ============= //
//   Resources   //
// ============= //

resource >singularMainResourceType< '>providerNamespace</>resourceType<@>apiVersion<' = {
  name: '>exampleResource<'
  properties: {
    ... // other properties
    zones: map(availabilityZones, zone => '${zone}')
  }
}
