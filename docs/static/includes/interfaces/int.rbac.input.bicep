roleAssignments: [
  {
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
    principalId: 'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx'
  }
  {
    roleDefinitionIdOrName: 'Storage Blob Data Reader'
    principalId: 'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy'
    principalType: 'Group'
    description: 'Group with read-only access'
    condition: '@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container''
    conditionVersion: '2.0'
  }
]
