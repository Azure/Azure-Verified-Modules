// ============== //
//   Parameters   //
// ============== //

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int

// ============= //
//   Resources   //
// ============= //

resource >singularMainResourceType< '>providerNamespace</>resourceType<@>apiVersion<' = {
  name: '>exampleResource<'
  properties: {
    ... // other properties
    zones: availabilityZone != -1 ? array(string(availabilityZone)) : null // If expecting an array
    // Or
    availabilityZone: availabilityZone != -1 ? string(availabilityZone) : null // If expecting a single value
  }
}
