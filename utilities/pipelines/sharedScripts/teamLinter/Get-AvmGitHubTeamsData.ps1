Function Get-AvmGitHubTeamsData {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [ValidateSet('AllTeams', 'AllResource', 'AllPattern', 'AllBicep', 'AllBicepResource', 'BicepResourceOwners', 'BicepResourceContributors', 'AllBicepPattern', 'BicepPatternOwners', 'BicepPatternContributors', 'AllTerraform', 'AllTerraformResource', 'TerraformResourceOwners', 'TerraformResourceContributors', 'AllTerraformPattern', 'TerraformPatternOwners', 'TerraformPatternContributors' )]
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
  # Filter AVM Module Teams for Bicep
  $filterAvmBicepGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*bicep' }
  # Filter AVM Module Teams for Bicep Resource Modules
  $filterAvmBicepResGhTeams = $filterAvmBicepGhTeams | Where-Object { $_.name -like '*res-*' }
  # Filter AVM Module Teams for Bicep Resource Modules Owners
  $filterAvmBicepResGhTeamsOwners = $filterAvmBicepResGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Bicep Resource Modules Contributors
  $filterAvmBicepResGhTeamsContributors = $filterAvmBicepResGhTeams | Where-Object { $_.name -like '*contributors-*' }
  # Filter AVM Module Teams for Bicep Pattern Modules
  $filterAvmBicepPtnGhTeams = $filterAvmBicepGhTeams | Where-Object { $_.name -like '*ptn-*' }
  # Filter AVM Module Teams for Bicep Pattern Modules Owners
  $filterAvmBicepPtnGhTeamsOwners = $filterAvmBicepPtnGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Bicep Pattern Modules Contributors
  $filterAvmBicepPtnGhTeamsContributors = $filterAvmBicepPtnGhTeams | Where-Object { $_.name -like '*contributors-*' }
  # Filter AVM Module Teams for Terraform
  $filterAvmTfGhTeams = $filterAvmGhTeams | Where-Object { $_.name -like '*tf' }
  # Filter AVM Module Teams for Terraform Resource Modules
  $filterAvmTfResGhTeams = $filterAvmTfGhTeams | Where-Object { $_.name -like '*res-*' }
  # Filter AVM Module Teams for Terraform Resource Modules Owners
  $filterAvmTfResGhTeamsOwners = $filterAvmTfResGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Terraform Resource Modules Contributors
  $filterAvmTfResGhTeamsContributors = $filterAvmTfResGhTeams | Where-Object { $_.name -like '*contributors-*' }
  # Filter AVM Module Teams for Terraform Pattern Modules
  $filterAvmTfPtnGhTeams = $filterAvmTfGhTeams | Where-Object { $_.name -like '*ptn-*' }
  # Filter AVM Module Teams for Terraform Pattern Modules Owners
  $filterAvmTfPtnGhTeamsOwners = $filterAvmTfPtnGhTeams | Where-Object { $_.name -like '*owners-*' }
  # Filter AVM Module Teams for Terraform Pattern Modules Contributors
  $filterAvmTfPtnGhTeamsContributors = $filterAvmTfPtnGhTeams | Where-Object { $_.name -like '*contributors-*' }

  switch ($TeamFilter) {
      'AllTeams' { return $filterAvmGhTeams }
      'AllResource' { return $filterAvmResGhTeams }
      'AllPattern' { return $filterAvmPtnGhTeams }
      'AllBicep' { return $filterAvmBicepGhTeams }
      'BicepResourceOwners' { return $filterAvmBicepResGhTeamsOwners }
      'BicepResourceContributors' { return $filterAvmBicepResGhTeamsContributors }
      'AllBicepResource' { return $filterAvmBicepResGhTeams }
      'AllBicepPattern' { return $filterAvmBicepPtnGhTeams }
      'BicepPatternOwners' { return $filterAvmBicepPtnGhTeamsOwners }
      'BicepPatternContributors' { return $filterAvmBicepPtnGhTeamsContributors }
      'AllTerraform' { return $filterAvmTfGhTeams }
      'AllTerraformResource' { return $filterAvmTfResGhTeams }
      'TerraformResourceOwners' { return $filterAvmTfResGhTeamsOwners }
      'TerraformResourceContributors' { return $filterAvmTfResGhTeamsContributors }
      'AllTerraformPattern' { return $filterAvmTfPtnGhTeams }
      'TerraformPatternOwners' { return $filterAvmTfPtnGhTeamsOwners }
      'TerraformPatternContributors' { return $filterAvmTfPtnGhTeamsContributors }
  }
}
