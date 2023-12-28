<#
.SYNOPSIS
Compares Azure Verified Modules Module Indexes with existing GitHub Teams configurations. Issues with GitHub teams can be converted to Github Issues or verbose output.

.DESCRIPTION
Compares Azure Verified Modules Module Indexes with existing GitHub Teams configurations. Issues with GitHub teams can be converted to Github Issues or verbose output.

.PARAMETER ModuleIndex
Required. Modules Index to use as source, allowed strings are:
'Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern'

.PARAMETER TeamFilter
Required. Teams to filter on, allowed strings are:
'AllTeams', 'AllResource', 'AllPattern', 'AllBicep', 'AllBicepResource', 'BicepResourceOwners', 'BicepResourceContributors', 'AllBicepPattern', 'BicepPatternOwners', 'BicepPatternContributors', 'AllTerraform', 'AllTerraformResource', 'TerraformResourceOwners', 'TerraformResourceContributors', 'AllTerraformPattern', 'TerraformPatternOwners', 'TerraformPatternContributors'

.PARAMETER ValidateBicepParentConfiguration
Optional. Validate if Parent Team is configured for Owners Team

.PARAMETER ValidateTerraformTeamsPermissons
Optional. Validate if correct permissions are configured for Terraform Teams

.PARAMETER CreateIssues
Optional. Create GitHub Issues for unmatched teams

.EXAMPLE
Invoke-AvmGitHubTeamLinter -ModuleIndex Bicep-Resource -TeamFilter AllBicepResource -ValidateBicepParentConfiguration -Verbose -CreateIssues

Compares all bicep resource modules with GitHub Teams and validates if Parent Team is configured for Owners Team. Verbose output is displayed and GitHub Issues are created for unmatched teams.

.EXAMPLE
Invoke-AvmGitHubTeamLinter -ModuleIndex Terraform-Resource -TeamFilter AllTerraformResource -ValidateTerraformTeamsPermissons -Verbose -CreateIssues

Compares all terraform resource modules with GitHub Teams and validates if Teams have correct permissions on repository. Verbose output is displayed and GitHub Issues are created for unmatched teams.

.EXAMPLE
Invoke-AvmGitHubTeamLinter -ModuleIndex Bicep-Pattern -TeamFilter AllBicepPattern -ValidateBicepParentConfiguration -Verbose

Compares all bicep pattern modules with GitHub Teams and validates if Parent Team is configured for Owners Team. Verbose output is displayed, GitHub Issues are not created for unmatched teams.
#>

Function Invoke-AvmGitHubTeamLinter {

  [CmdletBinding()]
  param (
      [Parameter(Mandatory)]
      [ValidateSet('Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern')]
      [string]$ModuleIndex,

      [Parameter(Mandatory)]
      [ValidateSet('AllTeams', 'AllResource', 'AllPattern', 'AllBicep', 'AllBicepResource', 'BicepResourceOwners', 'BicepResourceContributors', 'AllBicepPattern', 'BicepPatternOwners', 'BicepPatternContributors', 'AllTerraform', 'AllTerraformResource', 'TerraformResourceOwners', 'TerraformResourceContributors', 'AllTerraformPattern', 'TerraformPatternOwners', 'TerraformPatternContributors' )]
      [string]$TeamFilter,

      [Parameter(Mandatory = $false)]
      [switch]$ValidateBicepParentConfiguration,

      [Parameter(Mandatory = $false)]
      [switch]$ValidateTerraformTeamsPermissons,

      [Parameter(Mandatory = $false)]
      [switch]$CreateIssues
  )

  # Load used functions
  . (Join-Path $PSScriptRoot 'Get-AvmCsvData.ps1')
  . (Join-Path $PSScriptRoot 'Get-AvmGitHubTeamsData.ps1')
  . (Join-Path $PSScriptRoot 'Set-AvmGitHubTeamsIssue.ps1')
  . (Join-Path $PSScriptRoot 'Get-AvmGitHubTeamRepoConfiguration.ps1')

  if ($TeamFilter -like '*All*') {
      $validateAll = $true
  }

  if ($TeamFilter -like '*Owners*') {
      $validateOwnerTeams = $true
  }
  if ($TeamFilter -like '*Contributors*') {
      $validateContributorTeams = $true
  }

    # Retrieve the CSV file
    $sourceData = Get-AvmCsvData -ModuleIndex $ModuleIndex
    $gitHubTeamsData = Get-AvmGitHubTeamsData -TeamFilter $TeamFilter
    $unmatchedTeams = @()
    # Iterate through each object in $csv
    foreach ($module in $sourceData) {
      # Assume no match is found initially
      $matchFound = $false
      if ($validateOwnerTeams -Or $validateAll) {
          # Check each object in $ghTeam for a match
          foreach ($ghTeam in $gitHubTeamsData) {
              if ($module.ModuleOwnersGHTeam -eq $ghTeam.name) {
                  # If a match is found, set flag to true and break out of the loop
                  $matchFound = $true

                  # Validate if Parent Team is configured for Owners Team
                  if ($ValidateBicepParentConfiguration -and $matchFound) {
                      # Check if Parent Team is configured for Owners Team
                      if (-not $null -eq $ghTeam.parent -and $ValidateBicepParentConfiguration) {
                          Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) with parent: $($ghTeam.parent.name) owned by $($module.PrimaryModuleOwnerDisplayName)"
                          break
                      }
                      else {
                          Write-Verbose "Uh-oh no parent team configured for $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                          # Create a custom object for the unmatched team
                          $unmatchedTeam = [PSCustomObject]@{
                              TeamName       = $module.ModuleOwnersGHTeam
                              Validation     = "No parent team assigned."
                              Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                              GitHubTeamName = $ghTeam.name
                              Resolution     = "Assign the correct parent team to the team: $($module.ModuleOwnersGHTeam) [here](https://github.com/orgs/Azure/teams/$($module.ModuleContributorsGHTeam)). Parent information can be found in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only)."
                          }
                          # Add the custom object to the array
                          $unmatchedTeams += $unmatchedTeam
                          break
                      }
                  }
                  elseif ($ValidateTerraformTeamsPermissons -and $matchFound) {
                      Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) Checking Permissions configuration"
                      if ($module.ModuleOwnersGHTeam -like "*-tf") {
                          $repoName = "terraform-azurerm-$($module.ModuleName)"
                          $repoConfiguration = Get-AvmGitHubTeamRepoConfiguration -Organization Azure -TeamName $module.ModuleOwnersGHTeam -RepoName $repoName
                          if ($repoConfiguration -match "Success") {
                              Write-Verbose "Good News! Repo: $repoName is configured with the expected permission: admin"
                          }
                          else {
                              Write-Verbose "Uh-oh no correct permissions configured for $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                              # Create a custom object for the unmatched team
                              $unmatchedTeam = [PSCustomObject]@{
                                  TeamName       = $module.ModuleOwnersGHTeam
                                  Validation     = "No correct permissions assigned."
                                  Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                                  GitHubTeamName = $ghTeam.name
                                  Resolution     = "Please assign the correct permissions to the team: $($module.ModuleOwnersGHTeam). This can be found in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only)."
                              }
                              # Add the custom object to the array
                              $unmatchedTeams += $unmatchedTeam
                              break
                          }
                      }
                      else {
                          Write-Verbose "Skipping non Terraform module: $($module.ModuleOwnersGHTeam)"
                          break
                      }
                  }
                  elseif ($matchFound) {
                      # Write verbose output without parent check
                      Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                      break
                  }
              }


              # Check for match with "@Azure/" prefix
              # Construct the prefixed team name
              $prefixedTeamName = "@azure/" + $module.ModuleOwnersGHTeam

              # Check for match with "@Azure/" prefix
              if ($prefixedTeamName -eq $ghTeam.name) {
                  $matchFound = $true
                  Write-Verbose "Uh-oh team found with '@azure/' prefix for: $($ghTeam.name), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                  $unmatchedTeam = [PSCustomObject]@{
                      TeamName       = $module.ModuleOwnersGHTeam
                      Validation     = "@azure/ prefix found."
                      Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                      GitHubTeamName = $ghTeam.name
                      Resolution     = "Remove the '@azure/' prefix from the team name."
                  }
                  # Add the custom object to the array
                  $unmatchedTeams += $unmatchedTeam
                  break
              }
          }

          # If no match was found, output the item from $csv
          if (-not $matchFound) {
              Write-Verbose "No team found for: $($module.ModuleOwnersGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
              $unmatchedTeam = [PSCustomObject]@{
                  TeamName       = $module.ModuleOwnersGHTeam
                  Validation     = "GitHub team not found. "
                  Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                  GitHubTeamName = "N/A"
                  Resolution     = "Create a new team with the name $($module.ModuleOwnersGHTeam) [here](https://github.com/orgs/Azure/new-team)."
              }
              # Add the custom object to the array
              $unmatchedTeams += $unmatchedTeam
          }
      }

      if ($validateContributorTeams -Or $validateAll) {
          # Check each object in $ghTeam for a match
          foreach ($ghTeam in $gitHubTeamsData) {
              if ($module.ModuleContributorsGHTeam -eq $ghTeam.name) {
                  # If a match is found, set flag to true and break out of the loop
                  $matchFound = $true

                  # Validate if Parent Team is configured for Contributors Team
                  if ($ValidateBicepParentConfiguration -and $matchFound) {
                      # Check if Parent Team is configured for Contributors Team
                      if (-not $null -eq $ghTeam.parent -and $ValidateBicepParentConfiguration) {
                          Write-Verbose "Found team: $($module.ModuleContributorsGHTeam)  with parent: $($ghTeam.parent.name) owned by $($module.PrimaryModuleOwnerDisplayName)"
                          break
                      }
                      else {
                          Write-Verbose "Uh-oh no parent team configured for $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                          # Create a custom object for the unmatched team
                          $unmatchedTeam = [PSCustomObject]@{
                              TeamName       = $module.ModuleContributorsGHTeam
                              Validation     = "No parent team assigned."
                              Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                              GitHubTeamName = $ghTeam.name
                              Resolution     = "Assign the correct parent team to the team: $($module.ModuleContributorsGHTeam) [here](https://github.com/orgs/Azure/teams/$($module.ModuleContributorsGHTeam)). Parent information can be found in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only)."
                          }
                          # Add the custom object to the array
                          $unmatchedTeams += $unmatchedTeam
                      }
                  }
                  elseif ($ValidateTerraformTeamsPermissons -and $matchFound) {
                      Write-Verbose "Found team: $($module.ModuleContributorsGHTeam) Checking Permissions configuration"
                      if ($module.ModuleContributorsGHTeam -like "*-tf") {
                          $repoName = "terraform-azurerm-$($module.ModuleName)"
                          $repoConfiguration = Get-AvmGitHubTeamRepoConfiguration -Organization Azure -TeamName $module.ModuleContributorsGHTeam -RepoName $repoName
                          if ($repoConfiguration -match "Success") {
                              Write-Verbose "Good News! Repo: $repoName is configured with the expected permission: write"
                          }
                          else {
                              Write-Verbose "Uh-oh no correct permissions configured for $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                              # Create a custom object for the unmatched team
                              $unmatchedTeam = [PSCustomObject]@{
                                  TeamName       = $module.ModuleContributorsGHTeam
                                  Validation     = "No correct permissions assigned."
                                  Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                                  GitHubTeamName = $ghTeam.name
                                  Resolution     = "Please assign the correct permissions to the team: $($module.ModuleContributorsGHTeam). This can be found in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only)."
                              }
                              # Add the custom object to the array
                              $unmatchedTeams += $unmatchedTeam
                              break
                          }
                      }
                      else {
                          Write-Verbose "Skipping non Terraform module: $($module.ModuleContributorsGHTeam)"
                          break
                      }
                  }
                  elseif ($matchFound) {
                      Write-Verbose "Found team: $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                      break
                  }

              }

              # Check for match with "@Azure/" prefix
              # Construct the prefixed team name
              $prefixedTeamName = "@azure/" + $module.ModuleContributorsGHTeam

              # Check for match with "@Azure/" prefix
              if ($prefixedTeamName -eq $ghTeam.name) {
                  $matchFound = $true
                  Write-Verbose "Uh-oh team found with '@azure/' prefix for: $($ghTeam.name), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                  $unmatchedTeam = [PSCustomObject]@{
                      TeamName       = $module.ModuleContributorsGHTeam
                      Validation     = "@azure/ prefix found."
                      Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                      GitHubTeamName = $ghTeam.name
                      Resolution     = "Remove the '@azure/' prefix from the team name."
                  }
                  # Add the custom object to the array
                  $unmatchedTeams += $unmatchedTeam
                  break
              }
          }

          # If no match was found, output the item from $csv
          if (-not $matchFound) {
              Write-Verbose "No team found for: $($module.ModuleContributorsGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
              if (-not $matchFound) {
                  Write-Verbose "No team found for: $($module.ModuleContributorsGHTeam), Current Owner is $($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                  $unmatchedTeam = [PSCustomObject]@{
                      TeamName       = $module.ModuleContributorsGHTeam
                      Validation     = "GitHub team not found. "
                      Owner          = "$($module.PrimaryModuleOwnerGHHandle) ($($module.PrimaryModuleOwnerDisplayName))"
                      GitHubTeamName = "N/A"
                      Resolution     = "Create a new team with the name $($module.ModuleContributorsGHTeam) [here](https://github.com/orgs/Azure/new-team)."
                  }
                  # Add the custom object to the array
                  $unmatchedTeams += $unmatchedTeam
              }
          }
      }
  }
  # Check if $unmatchedTeams is empty
  if ($unmatchedTeams.Count -eq 0) {
      Write-Output "No unmatched teams found."
      $LASTEXITCODE = 0
  }
  else {
      $jsonOutput = $unmatchedTeams | ConvertTo-Json -Depth 3
      Write-Warning "Unmatched teams found:"
      Write-Warning $jsonOutput | Out-String

      if ($CreateIssues) {
          foreach ($unmatchedTeam in $unmatchedTeams) {
              Set-AvmGitHubTeamsIssue -TeamName $unmatchedTeam.TeamName -Owner $unmatchedTeam.Owner -ValidationError $unmatchedTeam.Validation -ResolutionInfo $unmatchedTeam.Resolution -CreateIssues:$true -Verbose
          }
      }
      else {
          foreach ($unmatchedTeam in $unmatchedTeams) {
              Set-AvmGitHubTeamsIssue -TeamName $unmatchedTeam.TeamName -Owner $unmatchedTeam.Owner -ValidationError $unmatchedTeam.Validation -ResolutionInfo $unmatchedTeam.Resolution -CreateIssues:$false -Verbose
          }
      }

      #Output in JSON for follow on tasks
      if (-not $CreateIssues) {
          Write-Output "::warning file=Invoke-AvmGitHubTeamLinter.ps1::Unmatched teams found, Review step warnings for details."
          Write-Output "## :warning: Unmatched teams found, Review step warnings for details." >> $env.GITHUB_STEP_SUMMARY -Verbose
          $LASTEXITCODE = 1
      }
      else {
          Write-Output "Unmatched teams found, Github issues Created."
          return $jsonOutput
      }
  }
}
