managed_identities = {
  system_assigned = true
  user_assigned_resource_ids = [
    "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}",
    "/subscriptions/{subscriptionId2}/resourceGroups/{resourceGroupName2}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName2}"
  ]
}
