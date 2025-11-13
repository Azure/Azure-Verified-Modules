Function Get-AvmGitHubTeamsData {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [ValidateSet('AllTeams', 'AllResource', 'AllPattern', 'AllUtility', 'AllBicep', 'AllBicepResource', 'BicepResourceOwners', 'AllBicepPattern', 'BicepPatternOwners', 'AllBicepUtility', 'BicepUtilityOwners', 'AllTerraform', 'AllTerraformResource', 'TerraformResourceOwners', 'AllTerraformPattern', 'TerraformPatternOwners', 'AllTerraformUtility', 'TerraformUtilityOwners' )]
      [string]$TeamFilter
  )

  try {
      # use githubCLI to get all teams in Azure organization
      $rawGhTeams = gh api orgs/Azure/teams --paginate
      $formattedGhTeams = ConvertFrom-Json $rawGhTeams
  }
  catch {
      Write-Error "Error: $_"
  }

  # Convert JSON to PowerShell Object

  # Filter Teams for AVM
  $filterAvmGhTeams = $formattedGhTeams | Where-Object { $_.name -like '*avm-*' }
  # Filter Teams for AVM Resource Modules
  $filterAvmResGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*res-*' }
  # Filter Teams for AVM Pattern Modules
  $filterAvmPtnGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*ptn-*' }
  # Filter Teams for AVM Utility Modules
  $filterAvmUtlGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*utl-*' }
  # Filter AVM Module Teams for Bicep
  $filterAvmBicepGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*bicep' }
  # Filter AVM Module Teams for Bicep Resource Modules
  $filterAvmBicepResGhTeams = $filterAvmBicepGhTeams | Where-Object { $_.name -like '*res-*' }
  # Filter AVM Module Teams for Bicep Resource Modules Owners
  $filterAvmBicepResGhTeamsOwners = $filterAvmBicepResGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Bicep Pattern Modules
  $filterAvmBicepPtnGhTeams = $filterAvmBicepGhTeams | Where-Object { $_.name -like '*ptn-*' }
  # Filter AVM Module Teams for Bicep Pattern Modules Owners
  $filterAvmBicepPtnGhTeamsOwners = $filterAvmBicepPtnGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Bicep Utility Modules
  $filterAvmBicepUtlGhTeams = $filterAvmBicepGhTeams | Where-Object { $_.name -like '*utl-*' }
  # Filter AVM Module Teams for Bicep Utility Modules Owners
  $filterAvmBicepUtlGhTeamsOwners = $filterAvmBicepUtlGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Terraform
  $filterAvmTfGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*tf' }
  # Filter AVM Module Teams for Terraform Resource Modules
  $filterAvmTfResGhTeams = $filterAvmTfGhTeams | Where-Object { $_.name -like '*res-*' }
  # Filter AVM Module Teams for Terraform Resource Modules Owners
  $filterAvmTfResGhTeamsOwners = $filterAvmTfResGhTeams | Where-Object { $_.name -like '*owners-*' }
    # Filter AVM Module Teams for Terraform Pattern Modules
  $filterAvmTfPtnGhTeams = $filterAvmTfGhTeams | Where-Object { $_.name -like '*ptn-*' }
  # Filter AVM Module Teams for Terraform Pattern Modules Owners
  $filterAvmTfPtnGhTeamsOwners = $filterAvmTfPtnGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Terraform Utility Modules
  $filterAvmTfUtlGhTeams = $filterAvmTfGhTeams | Where-Object { $_.name -like '*utl-*' }
  # Filter AVM Module Teams for Terraform Utility Modules Owners
  $filterAvmTfUtlGhTeamsOwners = $filterAvmTfUtlGhTeams | Where-Object { $_.name -like '*owners-*' }

  switch ($TeamFilter) {
      'AllTeams' { return $filterAvmGhTeams }
      'AllResource' { return $filterAvmResGhTeams }
      'AllPattern' { return $filterAvmPtnGhTeams }
      'AllUtility' { return $filterAvmUtlGhTeams }
      'AllBicep' { return $filterAvmBicepGhTeams }
      'BicepResourceOwners' { return $filterAvmBicepResGhTeamsOwners }
      'AllBicepResource' { return $filterAvmBicepResGhTeams }
      'AllBicepPattern' { return $filterAvmBicepPtnGhTeams }
      'BicepPatternOwners' { return $filterAvmBicepPtnGhTeamsOwners }
      'AllBicepUtility' { return $filterAvmBicepUtlGhTeams }
      'BicepUtilityOwners' { return $filterAvmBicepUtlGhTeamsOwners }
      'AllTerraform' { return $filterAvmTfGhTeams }
      'AllTerraformResource' { return $filterAvmTfResGhTeams }
      'TerraformResourceOwners' { return $filterAvmTfResGhTeamsOwners }
      'AllTerraformPattern' { return $filterAvmTfPtnGhTeams }
      'TerraformPatternOwners' { return $filterAvmTfPtnGhTeamsOwners }
      'AllTerraformUtility' { return $filterAvmTfUtlGhTeams }
      'TerraformUtilityOwners' { return $filterAvmTfUtlGhTeamsOwners }
  }
}
