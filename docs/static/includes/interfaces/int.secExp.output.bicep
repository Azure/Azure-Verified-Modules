
// Get all exported secret references
output exportedSecrets object = >deploymentReference<.outputs.exportedSecrets

// Get the resource Id of just the secret with name >secretToExport1<Name
output specificSecret string = >deploymentReference<.outputs.exportedSecrets.>secretToExport1<Name.secretResourceId

// Get the resource Ids of all secrets set
output exportedSecretResourceIds array = map(
  items(>deploymentReference<.outputs.exportedSecrets),
  item => item.value.secretResourceId
)
