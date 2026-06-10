<#
.SYNOPSIS
Build the consolidated module-index JSON files (`modules.json`, `bicep.json`, `terraform.json`) from the CSV indexes.

.DESCRIPTION
Reads the six module-index CSV files under `docs/static/module-indexes/` and writes three JSON files into the same folder:

* `modules.json`  – Array of all AVM modules. For resource modules, Bicep and Terraform entries with the same `ProviderNamespace`+`ResourceType` are merged into a single record. Pattern and utility modules are emitted one entry per ecosystem (no matching).
* `bicep.json`    – Map keyed by Bicep `ModuleName` (e.g. `avm/res/storage/storage-account`) containing the minimal info (`moduleType`, `displayName`, `status`) required by the Bicep VS Code intellisense extension (see https://github.com/Azure/bicep/pull/18958).
* `terraform.json` – Map keyed by Terraform `ModuleName` (e.g. `avm-res-storage-storageaccount`) with the same minimal shape.

Every record carries a `moduleType` field of `resource`, `pattern`, or `utility`. The `ModuleOwnersGHTeam` column (i.e. owner *groups*) is intentionally excluded from the output.

The function writes the files in a deterministic order (sorted keys / sorted records) so re-runs only produce a diff when the source CSVs actually change.

.PARAMETER ModuleIndexesFolderPath
Mandatory. Path to the folder containing the six module-index CSV files (and where the JSON outputs will be written).

.EXAMPLE
Set-ModuleIndexesJson -ModuleIndexesFolderPath './docs/static/module-indexes'
#>
function Set-ModuleIndexesJson {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $ModuleIndexesFolderPath
    )

    if (-not (Test-Path -Path $ModuleIndexesFolderPath -PathType Container)) {
        throw "Module indexes folder not found: [$ModuleIndexesFolderPath]"
    }

    # -------------------------------------------------------------------------
    # Helpers
    # -------------------------------------------------------------------------

    function Read-ModuleCsv {
        param (
            [Parameter(Mandatory)] [string] $Path,
            [Parameter(Mandatory)] [string] $Ecosystem,    # 'bicep' | 'terraform'
            [Parameter(Mandatory)] [string] $ModuleType    # 'resource' | 'pattern' | 'utility'
        )

        if (-not (Test-Path -Path $Path -PathType Leaf)) {
            Write-Warning "CSV not found: [$Path] - skipping."
            return @()
        }

        $rows = Import-Csv -Path $Path
        Write-Verbose "Loaded $($rows.Count) rows from [$Path]" -Verbose

        $result = @()
        foreach ($row in $rows) {
            $entry = [ordered]@{
                ecosystem  = $Ecosystem
                moduleType = $ModuleType
            }
            foreach ($prop in $row.PSObject.Properties) {
                # Skip the GitHub teams column ("groups") on purpose.
                if ($prop.Name -eq 'ModuleOwnersGHTeam') { continue }
                $entry[$prop.Name] = $prop.Value
            }
            $result += [pscustomobject]$entry
        }
        return , $result
    }

    function Convert-BicepRowToObject {
        param ([Parameter(Mandatory)] $Row)

        return [ordered]@{
            moduleName                    = $Row.ModuleName
            parentModule                  = $Row.ParentModule
            moduleStatus                  = $Row.ModuleStatus
            repoURL                       = $Row.RepoURL
            publicRegistryReference       = $Row.PublicRegistryReference
            telemetryIdPrefix             = $Row.TelemetryIdPrefix
            primaryModuleOwnerGHHandle    = $Row.PrimaryModuleOwnerGHHandle
            primaryModuleOwnerDisplayName = $Row.PrimaryModuleOwnerDisplayName
            secondaryModuleOwnerGHHandle  = $Row.SecondaryModuleOwnerGHHandle
            secondaryModuleOwnerDisplayName = $Row.SecondaryModuleOwnerDisplayName
            firstPublishedIn              = $Row.FirstPublishedIn
        }
    }

    function Convert-TerraformRowToObject {
        param ([Parameter(Mandatory)] $Row)

        return [ordered]@{
            moduleName                    = $Row.ModuleName
            moduleStatus                  = $Row.ModuleStatus
            repoURL                       = $Row.RepoURL
            publicRegistryReference       = $Row.PublicRegistryReference
            primaryModuleOwnerGHHandle    = $Row.PrimaryModuleOwnerGHHandle
            primaryModuleOwnerDisplayName = $Row.PrimaryModuleOwnerDisplayName
            secondaryModuleOwnerGHHandle  = $Row.SecondaryModuleOwnerGHHandle
            secondaryModuleOwnerDisplayName = $Row.SecondaryModuleOwnerDisplayName
            firstPublishedIn              = $Row.FirstPublishedIn
        }
    }

    function Get-ResourceMatchKey {
        param (
            [string] $ProviderNamespace,
            [string] $ResourceType
        )
        return ('{0}|{1}' -f $ProviderNamespace, $ResourceType).ToLowerInvariant()
    }

    # -------------------------------------------------------------------------
    # Load CSVs
    # -------------------------------------------------------------------------

    $bicepResRows = Read-ModuleCsv -Path (Join-Path $ModuleIndexesFolderPath 'BicepResourceModules.csv')   -Ecosystem 'bicep'     -ModuleType 'resource'
    $bicepPtnRows = Read-ModuleCsv -Path (Join-Path $ModuleIndexesFolderPath 'BicepPatternModules.csv')    -Ecosystem 'bicep'     -ModuleType 'pattern'
    $bicepUtlRows = Read-ModuleCsv -Path (Join-Path $ModuleIndexesFolderPath 'BicepUtilityModules.csv')    -Ecosystem 'bicep'     -ModuleType 'utility'
    $tfResRows    = Read-ModuleCsv -Path (Join-Path $ModuleIndexesFolderPath 'TerraformResourceModules.csv') -Ecosystem 'terraform' -ModuleType 'resource'
    $tfPtnRows    = Read-ModuleCsv -Path (Join-Path $ModuleIndexesFolderPath 'TerraformPatternModules.csv')  -Ecosystem 'terraform' -ModuleType 'pattern'
    $tfUtlRows    = Read-ModuleCsv -Path (Join-Path $ModuleIndexesFolderPath 'TerraformUtilityModules.csv')  -Ecosystem 'terraform' -ModuleType 'utility'

    # -------------------------------------------------------------------------
    # Build modules.json (array)
    # -------------------------------------------------------------------------

    $modules = New-Object System.Collections.Generic.List[object]

    # --- Resource modules: match top-level Bicep entries (ParentModule == 'n/a') with Terraform entries by ProviderNamespace+ResourceType.
    $tfResByKey = @{}
    foreach ($row in $tfResRows) {
        $key = Get-ResourceMatchKey -ProviderNamespace $row.ProviderNamespace -ResourceType $row.ResourceType
        if (-not $tfResByKey.ContainsKey($key)) {
            $tfResByKey[$key] = New-Object System.Collections.Generic.List[object]
        }
        $tfResByKey[$key].Add($row)
    }
    $usedTfKeys = New-Object System.Collections.Generic.HashSet[string]

    foreach ($row in $bicepResRows) {
        $isTopLevel = ($row.ParentModule -eq 'n/a')
        $key = Get-ResourceMatchKey -ProviderNamespace $row.ProviderNamespace -ResourceType $row.ResourceType

        $entry = [ordered]@{
            moduleType        = 'resource'
            providerNamespace = $row.ProviderNamespace
            resourceType      = $row.ResourceType
            moduleDisplayName = $row.ModuleDisplayName
            alternativeNames  = $row.AlternativeNames
            description       = $row.Description
            comments          = $row.Comments
            bicep             = Convert-BicepRowToObject -Row $row
            terraform         = $null
        }

        if ($isTopLevel -and $tfResByKey.ContainsKey($key)) {
            # Take the first Terraform match (multiple TF modules per provider+type is not expected).
            $tfMatch = $tfResByKey[$key][0]
            $entry.terraform = Convert-TerraformRowToObject -Row $tfMatch
            [void]$usedTfKeys.Add($key)
        }

        $modules.Add([pscustomobject]$entry)
    }

    # Terraform resource modules without a matching Bicep top-level row.
    foreach ($row in $tfResRows) {
        $key = Get-ResourceMatchKey -ProviderNamespace $row.ProviderNamespace -ResourceType $row.ResourceType
        if ($usedTfKeys.Contains($key)) { continue }

        $entry = [ordered]@{
            moduleType        = 'resource'
            providerNamespace = $row.ProviderNamespace
            resourceType      = $row.ResourceType
            moduleDisplayName = $row.ModuleDisplayName
            alternativeNames  = $row.AlternativeNames
            description       = $row.Description
            comments          = $row.Comments
            bicep             = $null
            terraform         = Convert-TerraformRowToObject -Row $row
        }
        $modules.Add([pscustomobject]$entry)
    }

    # --- Pattern and utility modules: one entry per ecosystem (no matching).
    foreach ($row in $bicepPtnRows) {
        $modules.Add([pscustomobject]([ordered]@{
                    moduleType        = 'pattern'
                    moduleDisplayName = $row.ModuleDisplayName
                    alternativeNames  = $row.AlternativeNames
                    description       = $row.Description
                    comments          = $row.Comments
                    bicep             = Convert-BicepRowToObject -Row $row
                    terraform         = $null
                }))
    }
    foreach ($row in $tfPtnRows) {
        $modules.Add([pscustomobject]([ordered]@{
                    moduleType        = 'pattern'
                    moduleDisplayName = $row.ModuleDisplayName
                    alternativeNames  = $row.AlternativeNames
                    description       = $row.Description
                    comments          = $row.Comments
                    bicep             = $null
                    terraform         = Convert-TerraformRowToObject -Row $row
                }))
    }
    foreach ($row in $bicepUtlRows) {
        $modules.Add([pscustomobject]([ordered]@{
                    moduleType        = 'utility'
                    moduleDisplayName = $row.ModuleDisplayName
                    alternativeNames  = $row.AlternativeNames
                    description       = $row.Description
                    comments          = $row.Comments
                    bicep             = Convert-BicepRowToObject -Row $row
                    terraform         = $null
                }))
    }
    foreach ($row in $tfUtlRows) {
        $modules.Add([pscustomobject]([ordered]@{
                    moduleType        = 'utility'
                    moduleDisplayName = $row.ModuleDisplayName
                    alternativeNames  = $row.AlternativeNames
                    description       = $row.Description
                    comments          = $row.Comments
                    bicep             = $null
                    terraform         = Convert-TerraformRowToObject -Row $row
                }))
    }

    # Sort the array deterministically so re-runs produce a stable diff.
    $sortedModules = $modules | Sort-Object `
        @{ Expression = { $_.moduleType } },
        @{ Expression = { if ($_.providerNamespace) { $_.providerNamespace.ToLowerInvariant() } else { '' } } },
        @{ Expression = { if ($_.resourceType) { $_.resourceType.ToLowerInvariant() } else { '' } } },
        @{ Expression = { if ($_.bicep) { $_.bicep.moduleName } elseif ($_.terraform) { $_.terraform.moduleName } else { '' } } }

    # -------------------------------------------------------------------------
    # Build bicep.json (map) - minimal data for VS Code intellisense
    # -------------------------------------------------------------------------

    $bicepMap = [ordered]@{}
    foreach ($pair in @(
            @{ Rows = $bicepResRows; Type = 'resource' },
            @{ Rows = $bicepPtnRows; Type = 'pattern' },
            @{ Rows = $bicepUtlRows; Type = 'utility' }
        )) {
        foreach ($row in ($pair.Rows | Sort-Object ModuleName)) {
            if (-not $row.ModuleName) { continue }
            $bicepMap[$row.ModuleName] = [ordered]@{
                moduleType  = $pair.Type
                displayName = $row.ModuleDisplayName
                status      = $row.ModuleStatus
            }
        }
    }

    # -------------------------------------------------------------------------
    # Build terraform.json (map) - minimal data, mirroring bicep.json
    # -------------------------------------------------------------------------

    $terraformMap = [ordered]@{}
    foreach ($pair in @(
            @{ Rows = $tfResRows; Type = 'resource' },
            @{ Rows = $tfPtnRows; Type = 'pattern' },
            @{ Rows = $tfUtlRows; Type = 'utility' }
        )) {
        foreach ($row in ($pair.Rows | Sort-Object ModuleName)) {
            if (-not $row.ModuleName) { continue }
            $terraformMap[$row.ModuleName] = [ordered]@{
                moduleType  = $pair.Type
                displayName = $row.ModuleDisplayName
                status      = $row.ModuleStatus
            }
        }
    }

    # -------------------------------------------------------------------------
    # Write output files
    # -------------------------------------------------------------------------

    $outputs = @(
        @{ FileName = 'modules.json';   Content = ,@($sortedModules) },
        @{ FileName = 'bicep.json';     Content = $bicepMap },
        @{ FileName = 'terraform.json'; Content = $terraformMap }
    )

    foreach ($out in $outputs) {
        $filePath = Join-Path $ModuleIndexesFolderPath $out.FileName
        $json = $out.Content | ConvertTo-Json -Depth 100
        # Ensure trailing newline and LF endings for stable diffs.
        $json = ($json -replace "`r`n", "`n").TrimEnd("`n") + "`n"

        if ($PSCmdlet.ShouldProcess("File [$filePath]", 'Write JSON')) {
            [System.IO.File]::WriteAllText($filePath, $json, [System.Text.UTF8Encoding]::new($false))
            Write-Verbose "Wrote [$filePath] ($([Math]::Round((Get-Item $filePath).Length / 1KB, 1)) KB)" -Verbose
        }
    }
}
