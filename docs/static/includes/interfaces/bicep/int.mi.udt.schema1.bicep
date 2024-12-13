
// ============== //
//   Parameters   //
// ============== //

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

// ============= //
//   Variables   //
// ============= //

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

// ============= //
//   Resources   //
// ============= //

resource >singularMainResourceType< '>providerNamespace</>resourceType<@>apiVersion<' = {
  name: name
  identity: identity
  properties: {
    ... // other properties
  }
}

// =========== //
//   Outputs   //
// =========== //

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = >singularMainResourceType<.?identity.?principalId
