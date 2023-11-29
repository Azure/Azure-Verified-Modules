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

.PARAMETER ValidateOwnersParent
Optional. Validate if Parent Team is configured for Owners Team

.PARAMETER ValidateContributorsParent
Optional. Validate if Parent Team is configured for Contributors Team

.PARAMETER CreateIssues
Optional. Create GitHub Issues for unmatched teams

.EXAMPLE
Compare-AvmTeams -ModuleIndex Bicep-Resource -TeamFilter AllBicepResource -ValidateOwnersParent -Verbose -CreateIssues

Compares all bicep resource modules with GitHub Teams and validates if Parent Team is configured for Owners Team. Verbose output is displayed and GitHub Issues are created for unmatched teams.

.EXAMPLE
Compare-AvmTeams -ModuleIndex Terraform-Resource -TeamFilter AllTerraformResource -ValidateOwnersParent -Verbose -CreateIssues

Compares all terraform resource modules with GitHub Teams and validates if Parent Team is configured for Owners Team. Verbose output is displayed and GitHub Issues are created for unmatched teams.

.EXAMPLE
Compare-AvmTeams -ModuleIndex Bicep-Pattern -TeamFilter AllBicepPattern -ValidateOwnersParent -Verbose

Compares all bicep pattern modules with GitHub Teams and validates if Parent Team is configured for Owners Team. Verbose output is displayed, GitHub Issues are not created for unmatched teams.
#>

Function Compare-AvmTeams {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Bicep-Resource', 'Bicep-Pattern', 'Terraform-Resource', 'Terraform-Pattern')]
        [string]$ModuleIndex,
        
        [Parameter(Mandatory)]
        [ValidateSet('AllTeams', 'AllResource', 'AllPattern', 'AllBicep', 'AllBicepResource', 'BicepResourceOwners', 'BicepResourceContributors', 'AllBicepPattern', 'BicepPatternOwners', 'BicepPatternContributors', 'AllTerraform', 'AllTerraformResource', 'TerraformResourceOwners', 'TerraformResourceContributors', 'AllTerraformPattern', 'TerraformPatternOwners', 'TerraformPatternContributors' )]

        [string]$TeamFilter,

        [switch]$ValidateOwnersParent,

        [switch]$ValidateContributorsParent,
        
        [switch]$CreateIssues
    )

    # Load used functions
    . (Join-Path $PSScriptRoot 'Get-AvmCsvData.ps1')
    . (Join-Path $PSScriptRoot 'Get-AvmGitHubTeamsData.ps1')
    . (Join-Path $PSScriptRoot 'Set-AvmGitHubTeamsIssue.ps1')

    if ($TeamFilter -like '*All*') {
        $validateAll = $true
    }

    if ($TeamFilter -like '*Owners*') {
        $validateOwners = $true
    }
    if ($TeamFilter -like '*Contributors*') {
        $validateContributors = $true
    }

    # Retrieve the CSV file
    $sourceData = Get-AvmCsv -ModuleIndex $ModuleIndex
    $gitHubTeamsData = Get-GitHubTeams -TeamFilter $TeamFilter
    $unmatchedTeams = @()
    # Iterate through each object in $csv
    foreach ($module in $sourceData) {
        # Assume no match is found initially
        $matchFound = $false
        if ($validateOwners -Or $validateAll) {
            # Check each object in $ghTeam for a match
            foreach ($ghTeam in $gitHubTeamsData) {
                if ($module.ModuleOwnersGHTeam -eq $ghTeam.name) {
                    # If a match is found, set flag to true and break out of the loop
                    $matchFound = $true

                    # Validate if Parent Team is configured for Owners Team
                    if ($ValidateOwnersParent) {
                        # Check if Parent Team is configured for Owners Team
                        if (-not $null -eq $ghTeam.parent -And $ValidateOwnersParent) {
                            Write-Verbose "Found team: $($module.ModuleOwnersGHTeam) with parent: $($ghTeam.parent.name) owned by $($module.PrimaryModuleOwnerDisplayName)"
                            break
                        }
                        else {
                            Write-Verbose "Uh-oh no parent team configured for $($module.ModuleOwnersGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                            # Create a custom object for the unmatched team
                            $unmatchedTeam = [PSCustomObject]@{
                                TeamName       = $module.ModuleOwnersGHTeam
                                Validation     = "No parent team assigned."
                                Owner          = "@me"
                                GitHubTeamName = $ghTeam.name
                                Resolution     = "Assign the correct parent team to the team: $($module.ModuleOwnersGHTeam). This can be found in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) "
                            }
                            # Add the custom object to the array
                            $unmatchedTeams += $unmatchedTeam
                            break
                        }
                    }
                    else {
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
                    Resolution     = "Create a new team with the name $($module.ModuleOwnersGHTeam)"
                }
                # Add the custom object to the array
                $unmatchedTeams += $unmatchedTeam
            }
        }

        if ($validateContributors -Or $validateAll) {
            # Check each object in $ghTeam for a match
            foreach ($ghTeam in $gitHubTeamsData) {
                if ($module.ModuleContributorsGHTeam -eq $ghTeam.name) {
                    # If a match is found, set flag to true and break out of the loop
                    $matchFound = $true
                    
                    # Validate if Parent Team is configured for Contributors Team
                    if ($ValidateContributorsParent) {
                        # Check if Parent Team is configured for Contributors Team
                        if (-not $null -eq $ghTeam.parent -And $ValidateContributorsParent) {
                            Write-Verbose "Found team: $($module.ModuleContributorsGHTeam)  with parent: $($ghTeam.parent.name) owned by $($module.PrimaryModuleOwnerDisplayName)"
                            break
                        }
                        else {
                            Write-Verbose "Uh-oh no parent team configured for $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                            # Create a custom object for the unmatched team
                            $unmatchedTeam = [PSCustomObject]@{
                                TeamName       = $module.ModuleContributorsGHTeam
                                Validation     = "No parent team assigned."
                                Owner          = "@me"
                                GitHubTeamName = $ghTeam.name
                                Resolution     = "Assign the correct parent team to the team: $($module.ModuleContributorsGHTeam). This can be found in [SNFR20](https://azure.github.io/Azure-Verified-Modules/specs/shared/#id-snfr20---category-contributionsupport---github-teams-only) "
                            }
                            # Add the custom object to the array
                            $unmatchedTeams += $unmatchedTeam
                        }
                    }
                    else {
                        Write-Verbose "Found team: $($module.ModuleContributorsGHTeam) ($($module.PrimaryModuleOwnerDisplayName))"
                    }
                    break
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
                        Resolution     = "Create a new team with the name $($module.ModuleContributorsGHTeam)"
                    }
                    # Add the custom object to the array
                    $unmatchedTeams += $unmatchedTeam
                }
            }
        }
    }
    # Check if $unmatchedTeams is empty
    if ($unmatchedTeams.Count -eq 0) {
        Write-Host "No unmatched teams found."
        $LASTEXITCODE = 0
    } 
    else {
        $jsonOutput = $unmatchedTeams | ConvertTo-Json -Depth 3
        $jsonString = $jsonOutput | Out-String
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
            Write-Output "::warning file=Compare-AvmTeams.ps1::Unmatched teams found, Review step warnings for details."
            Write-Output "## :warning: Unmatched teams found, Review step warnings for details." >> $env.GITHUB_STEP_SUMMARY -Verbose
            $LASTEXITCODE = 1
        }
        else {
            Write-Output "Unmatched teams found, Github issues Created."
            return $jsonOutput
        }
    } 
}