// ============== //
//   Parameters   //
// ============== //

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

// ============= //
//   Variables   //
// ============= //

// If user-assiged identities are supported => Adds any user assigned identity specified in the customer managed key definition to the general managed-identity spcification
var formattedUserAssignedIdentities = reduce(
  map(
    union(
      (managedIdentities.?userAssignedResourceIds ?? []),
      (!empty(customerManagedKey.?userAssignedIdentityResourceId)
        ? [customerManagedKey.?userAssignedIdentityResourceId]
        : [])
    ),
    (id) => { '${id}': {} }
  ),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) || !empty(formattedUserAssignedIdentities) 
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(formattedUserAssignedIdentities) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(formattedUserAssignedIdentities) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

// ============= //
//   Resources   //
// ============= //

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource >singularMainResourceType< '>providerNamespace</>resourceType<@>apiVersion<' = {
  name: '>exampleResource<'
  properties: {
    ... // other properties
    encryption: !empty(customerManagedKey)
      ? {
          keySource: 'Microsoft.KeyVault'
          keyVaultProperties: {
            keyVaultUri: cMKKeyVault.properties.vaultUri
            keyName: customerManagedKey!.keyName
            keyVersion: !empty(customerManagedKey.?keyVersion)
              ? customerManagedKey!.keyVersion!
              : last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
            keyIdentifier: !empty(customerManagedKey.?keyVersion)
              ? '${cMKKeyVault::cMKKey!.properties.keyUri}/${customerManagedKey!.keyVersion!}'
              : cMKKeyVault::cMKKey!.properties.keyUriWithVersion
            identityClientId: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? cMKUserAssignedIdentity!.properties.clientId
              : null
            identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? {
                  userAssignedIdentity: cMKUserAssignedIdentity!.id
                }
              : null
          }
        }
      : null
  }
}
