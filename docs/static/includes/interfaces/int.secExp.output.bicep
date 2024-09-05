
// Get all exported secret references
output exportedSecrets object = >deploymentReference<.outputs.exportedSecrets

// Get the resource Id of just the secret with name >secretToExportName1<
output specificSecret string = >deploymentReference<.outputs.exportedSecrets.>secretToExportName1<.secretResourceId

// Get the resource Ids of all secrets set
output exportedSecretResourceIds array = map(
  items(>deploymentReference<.outputs.exportedSecrets),
  item => item.value.secretResourceId
)
