roleAssignments: [
  {
    roleDefinitionIdOrName: 'Owner'
    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
  {
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
  {
    roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
    principalId: nestedDependencies.outputs.managedIdentityPrincipalId
    principalType: 'ServicePrincipal'
  }
  {
    name: guid('Custom role assignment name seed')
    roleDefinitionIdOrName: 'Storage Blob Data Reader'
    principalId: '00000000-0000-0000-0000-000000000000'
    principalType: 'Group'
    description: 'Group with read-only access'
    condition: '@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container''
    conditionVersion: '2.0'
  }
]
