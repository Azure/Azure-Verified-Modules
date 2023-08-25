@description('''Required. You can provide either the display name (note not all roles are supported, check module documentation) of the role definition, or its fully qualified ID in the following format: `/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11`.''')
param roleDefinitionIdOrName string

var builtInRbacRoleNames = {
  Owner: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: '/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Role Based Access Control Administrator (Preview)': '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  'User Access Administrator': '/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  //Other RBAC Role Definitions Names & IDs can be added here as needed for your module
}

var roleDefinitionIdMappedResult = (contains(builtInRbacRoleNames, roleDefinitionIdOrName) ? builtInRbacRoleNames[roleDefinitionIdOrName] : roleDefinitionIdOrName)

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  //Other properties removed for ease of reading
  properties: {
    roleDefinitionId: roleDefinitionIdMappedResult
    //Other properties removed for ease of reading
  }
}
