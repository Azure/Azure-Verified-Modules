
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
      contains(secretsExportConfiguration!, '>secretToExportName1<')
        ? [
            {
              name: secretsExportConfiguration!.>secretToExportName1<
              value: >secretReference1< // e.g., >singularMainResourceType<.listKeys().primaryMasterKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, '>secretToExportName2<')
        ? [
            {
              name: secretsExportConfiguration!.>secretToExportName2<
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

@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The >secretToExport1< secret name to create.')
  >secretToExportName1<: string?

  @description('Optional. The >secretToExport2< secret name to create.')
  >secretToExportName2<: string?

  // (...)
}

import { secretSetType } from 'modules/keyVaultExport.bicep'
type secretsOutputType = {
  @description('An exported secret\'s references.')
  *: secretSetType
}
