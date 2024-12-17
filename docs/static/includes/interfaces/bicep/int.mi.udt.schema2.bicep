
// ============== //
//   Parameters   //
// ============== //

import { managedIdentityOnlySysAssignedType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlySysAssignedType?

// ============= //
//   Variables   //
// ============= //

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false) ? 'SystemAssigned' : null
    }
  : null

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
