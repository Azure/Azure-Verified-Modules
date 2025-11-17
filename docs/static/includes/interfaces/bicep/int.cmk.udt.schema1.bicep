// ============== //
//   Parameters   //
// ============== //

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType?

// ============= //
//   Variables   //
// ============= //

var isHSMManagedCMK = split(customerManagedKey.?keyVaultResourceId ?? '', '/')[?7] == 'managedHSMs'

// ============= //
//   Resources   //
// ============= //

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2025-05-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
  name: last(split((customerManagedKey!.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey!.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey!.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2025-05-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
    name: customerManagedKey!.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey!.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey!.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey!.?userAssignedIdentityResourceId!, '/')[4]
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
            keyVaultUri: !isHSMManagedCMK
                ? cMKKeyVault!.properties.vaultUri
                : 'https://${last(split((customerManagedKey!.keyVaultResourceId), '/'))}.managedhsm.azure.net/'
            keyName: customerManagedKey!.keyName
            keyVersion: !empty(customerManagedKey!.?keyVersion)
              ? customerManagedKey!.keyVersion!
              : (!isHSMManagedCMK
                ? last(split(cMKKeyVault::cMKKey!.properties.keyUriWithVersion, '/'))
                : fail('Managed HSM CMK encryption requires specifying the \'keyVersion\'.'))
            keyIdentifier: !empty(customerManagedKey!.?keyVersion)
              ? ( !isHSMManagedCMK
                ? '${cMKKeyVault::cMKKey!.properties.keyUri}/${customerManagedKey!.keyVersion!}'
                : 'https://${last(split((customerManagedKey!.keyVaultResourceId), '/'))}.managedhsm.azure.net/keys/${customerManagedKey!.keyName}/${customerManagedKey!.keyVersion!}')
              : ( !isHSMManagedCMK
                ? cMKKeyVault::cMKKey!.properties.keyUriWithVersion
                : fail('Managed HSM CMK encryption requires specifying the \'keyVersion\'.'))
            identityClientId: !empty(customerManagedKey!.?userAssignedIdentityResourceId)
              ? cMKUserAssignedIdentity!.properties.clientId
              : null
            identity: !empty(customerManagedKey!.?userAssignedIdentityResourceId)
              ? {
                  userAssignedIdentity: cMKUserAssignedIdentity!.id
                }
              : null
          }
        }
      : null
  }
}
