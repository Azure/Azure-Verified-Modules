role_assignments = {
  role_assignment_1 = {
    role_definition_id_or_name             = "Contributor"
    principal_id                           = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
    skip_service_principal_aad_check       = true
  },
  role_assignment_2 = {
    role_definition_id_or_name             = "Storage Blob Data Reader"
    principal_id                           = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy"
    description                            = "Example role assignment 2 of reader role"
    skip_service_principal_aad_check       = false
    condition                              = "@Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase 'foo_storage_container'"
    condition_version                      = "2.0"
  }
}
