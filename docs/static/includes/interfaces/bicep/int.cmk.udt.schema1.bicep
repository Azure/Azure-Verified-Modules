// ============== //
//   Parameters   //
// ============== //

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

// ============= //
//   Variables   //
// ============= //

var keyVaultType = !empty(customerManagedKey.?keyVaultResourceId)
  ? split(customerManagedKey.?keyVaultResourceId!, '/')[7]
  : ''
var isHSMKeyVault = contains(keyVaultType, 'managedHSMs')

// ============= //
//   Resources   //
// ============= //

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!isHSMKeyVault && !empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource hSMCMKKeyVault 'Microsoft.KeyVault/managedHSMs@2024-11-01' existing = if (isHSMKeyVault && !empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource hSMCMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName
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
            keyVaultUri: !isHSMKeyVault ? cMKKeyVault!.properties.vaultUri : hSMCMKKeyVault!.properties.hsmUri
            keyName: customerManagedKey!.keyName
            keyVersion: !empty(customerManagedKey.?keyVersion)
              ? customerManagedKey!.keyVersion!
              : !isHSMKeyVault
                ? last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
                : last(split(hSMCMKKeyVault::hSMCMKKey!.properties.keyUriWithVersion, '/'))
            // TODO Update keyIdentifier HSM condition
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
