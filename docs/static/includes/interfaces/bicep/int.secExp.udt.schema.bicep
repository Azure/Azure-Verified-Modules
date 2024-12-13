
// ============== //
//   Parameters   //
// ============== //

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

// ============= //
//   Resources   //
// ============= //

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name, location)}-secrets-kv'
  scope: resourceGroup(
    split((secretsExportConfiguration.?keyVaultResourceId ?? '//'), '/')[2],
    split((secretsExportConfiguration.?keyVaultResourceId ?? '////'), '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId ?? '//', '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, '>secretToExport1<Name')
        ? [
            {
              name: secretsExportConfiguration!.>secretToExport1<Name
              value: >secretReference1< // e.g., >singularMainResourceType<.listKeys().primaryMasterKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, '>secretToExport2<Name')
        ? [
            {
              name: secretsExportConfiguration!.>secretToExport2<Name
              value:>secretReference2<  // e.g., >singularMainResourceType<.listKeys().secondaryMasterKey
            }
          ]
        : []
        // (...)
    )
  }
}

// =========== //
//   Outputs   //
// =========== //

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:>version<'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

@export()
type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The >secretToExport1< secret name to create.')
  >secretToExport1<Name: string?

  @description('Optional. The >secretToExport2< secret name to create.')
  >secretToExport2<Name: string?

  // (...)
}
