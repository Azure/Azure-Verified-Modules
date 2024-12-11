// ============== //
//   Parameters   //
// ============== //

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

// ============= //
//   Resources   //
// ============= //

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
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
            keyVersion: !empty(customerManagedKey.?keyVersion ?? '')
              ? customerManagedKey!.keyVersion
              : last(split(cMKKeyVault::cMKKey.properties.keyUriWithVersion, '/'))
            keyIdentifier: !empty(customerManagedKey.?keyVersion ?? '')
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
              : cMKKeyVault::cMKKey.properties.keyUriWithVersion
            identityClientId: !empty(customerManagedKey.?userAssignedIdentityResourceId ?? '')
              ? cMKUserAssignedIdentity.properties.clientId
              : null
            identity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? {
                  userAssignedIdentity: cMKUserAssignedIdentity.id
                }
              : null
          }
        }
      : null
  }
}
