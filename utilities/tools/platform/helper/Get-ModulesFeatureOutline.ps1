<#
.SYNOPSIS
Get an outline of all modules features for each module contained in the given path

.DESCRIPTION
Get a list of objects that outline of all modules features for each module contained in the given path (for example child-modules, RBAC, Private Endpoints, etc.)

NOTE: Currently only supports modules using the Bicep DSL

.PARAMETER ModulesFolderPath
Mandatory. The path to the modules.

.PARAMETER ModulesRepoRootPath
Mandatory. The path to the root of the repository containing the modules.

.PARAMETER ReturnFormat
Optional. Control the result format. Supports 'object', a CSV with columns containing the data, or a markdown table containing the data

.PARAMETER BreakMarkdownModuleNameAt
Optional. When `ReturnFormat` is set to 'Markdown' you can use this number to control if & where you'd want to line break the ModuleName column. Defaults to 1 (i.e., right after the provider namepsace).

.PARAMETER SearchDepth
Optional. Control in which depth to search for `main.bicep` files in the given 'ModulesRepoRootPath'

.PARAMETER ColumnsToInclude
Optional. An array that controls which columns / data points should be added to the result object. Defaults to all columns. The following columns are available:
- Status: Adds a column with the workflow status badge for the module
- RBAC: Adds a column indicating if the module supports RBAC
- Locks: Adds a column indicating if the module supports Locks
- Tags: Adds a column indicating if the module supports Tags
- Diag: Adds a column indicating if the module supports Diagnostic Settings
- PE: Adds a column indicating if the module supports Private Endpoints
- PIP: Adds a column indicating if the module supports Public IP Addresses

.PARAMETER RepositoryName
Optional. The name of the repository the code resides in. Required if 'ColumnsToInclude.Status' is 'true'

.PARAMETER Organization
Optional. The name of the Organization the code resides in. Required if 'ColumnsToInclude.Status' is 'true'

.EXAMPLE
Get-ModulesFeatureOutline -ReturnFormat 'Markdown' -SearchDepth 2 -ModulesFolderPath 'bicep-registry-modules/avm/res' -ModulesRepoRootPath 'bicep-registry-modules'

Get an outline of top-level (from 'res' 2 level down) modules in the 'bicep-registry-modules/avm/res' folder path, formatted in a markdown table.

.EXAMPLE
Get-ModulesFeatureOutline -ReturnFormat 'Markdown' -BreakMarkdownModuleNameAt 2 -ModulesFolderPath 'bicep-registry-modules/avm/res' -ModulesRepoRootPath 'bicep-registry-modules'

Get an outline of all modules in the 'bicep-registry-modules/avm/res' folder path, formatted in a markdown table - with the module name column split after the top-level (i.e., <ProviderNamespace>/<ResourceType)

.EXAMPLE
Get-ModulesFeatureOutline -ReturnFormat 'Markdown' -BreakMarkdownModuleNameAt 2 -RepositoryName 'bicep-registry-modules' -Organization 'Azure' -ModulesFolderPath 'bicep-registry-modules/avm/res' -ModulesRepoRootPath 'bicep-registry-modules'

Get an outline of all modules in the 'bicep-registry-modules/avm/res' folder path, formatted in a markdown table - with the module name column split after the top-level (i.e., <ProviderNamespace>/<ResourceType).

.EXAMPLE
Get-ModulesFeatureOutline -ReturnFormat 'CSV' -ColumnsToInclude @( 'Status', 'PE' ) -RepositoryName 'bicep-registry-modules' -Organization 'Azure' -ModulesFolderPath 'bicep-registry-modules/avm' -ModulesRepoRootPath 'bicep-registry-modules' -SearchDepth 2

Get an outline of all modules in the 'bicep-registry-modules/avm' folder path, formatted in a CSV format - with only the Columns 'Status' & 'PE'.

.NOTES
Children (if any) are displayed in format `[L1:5, L2:4, L3:1]`. Each item (separated via ',') shows the level of nesting in the front (e.g. L1) and the number of children in this level (separated by a colon ':').
In the above example, the module has 5 direct children, 4 of them have direct children themselves and 1 of them has 1 more child.
#>
function Get-ModulesFeatureOutline {

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseOutputTypeCorrectly', '', Justification='It has 3 different output types, not one. It''s a false-positive.')]
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '', Justification='For Join-Path it''s very difficult to read the cmdlet without positional parameters.')]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string] $ModulesFolderPath,

        [Parameter(Mandatory = $true)]
        [string] $ModulesRepoRootPath,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Status', 'RBAC', 'Locks', 'Tags', 'Diag', 'PE', 'PIP')]
        [string[]] $ColumnsToInclude = @(
            'Status',
            'RBAC',
            'Locks',
            'Tags',
            'Diag',
            'PE',
            'PIP'
        ),

        [Parameter(Mandatory = $false)]
        [ValidateSet('Object', 'Markdown', 'CSV')]
        [string] $ReturnFormat = 'Object',

        [Parameter(Mandatory = $false)]
        [int] $BreakMarkdownModuleNameAt = 2,

        [Parameter(Mandatory = $false)]
        [int] $SearchDepth,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName = 'bicep-registry-modules',

        [Parameter(Mandatory = $false)]
        [string] $Organization = 'Azure'
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'Get-PipelineStatusUrl.ps1')
    . (Join-Path $PSScriptRoot 'Get-PipelineFileName.ps1')

    $childInput = @{
        Path    = $ModulesFolderPath
        Recurse = $true
        File    = $true
        Filter  = 'main.bicep'
    }
    if ($SearchDepth) { $childInput.Depth = $SearchDepth }
    $moduleTemplatePaths = (Get-ChildItem @childInput).FullName

    ####################
    #   Collect data   #
    ####################
    $moduleData = [System.Collections.ArrayList]@()
    $summaryData = [ordered]@{}
    if ($ColumnsToInclude -contains 'RBAC') { $summaryData.supportsRBAC = 0 }
    if ($ColumnsToInclude -contains 'Locks') { $summaryData.supportsLocks = 0 }
    if ($ColumnsToInclude -contains 'Tags') { $summaryData.supportsTags = 0 }
    if ($ColumnsToInclude -contains 'Diag') { $summaryData.supportsDiagnostics = $_.Diag }
    if ($ColumnsToInclude -contains 'PE') { $summaryData.supportsEndpoints = 0 }
    if ($ColumnsToInclude -contains 'PIP') { $summaryData.supportsPipDeployment = 0 }

    foreach ($moduleTemplatePath in $moduleTemplatePaths) {

        $fullResourcePath = (((Split-Path $moduleTemplatePath -Parent) -replace '\\', '/') -split '/avm/')[1]
        $moduleContentString = Get-Content -Path $moduleTemplatePath -Raw

        $moduleDataItem = [ordered]@{
            Module = $fullResourcePath
        }

        # Status Badge
        $moduleFolderPath = Split-Path $moduleTemplatePath -Parent
        $relativeFolderPath = Join-Path 'avm' ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}')[1]
        $resourceTypeIdentifier = ($moduleFolderPath -split '[\/|\\]{1}avm[\/|\\]{1}(res|ptn)[\/|\\]{1}')[2] -replace '\\', '/' # avm/res/<provider>/<resourceType>
        $isTopLevelModule = ($resourceTypeIdentifier -split '[\/|\\]').Count -eq 2
        if (($ColumnsToInclude -contains 'Status') -and $isTopLevelModule) {

            $statusInputObject = @{
                RepositoryName      = $RepositoryName
                Organization        = $Organization
                PipelineFileName    = Get-PipelineFileName -ResourceIdentifier $relativeFolderPath
                WorkflowsFolderPath = Join-Path $ModulesRepoRootPath '.github' 'workflows'
            }

            $moduleDataItem['Status'] = Get-PipelineStatusUrl @statusInputObject
        }

        # Supports RBAC
        if ($ColumnsToInclude -contains 'RBAC') {
            if ([regex]::Match($moduleContentString, '(?m)^\s*param roleAssignments roleAssignmentType').Success) {
                $summaryData.supportsRBAC++
                $moduleDataItem['RBAC'] = $true
            } else {
                $moduleDataItem['RBAC'] = $false
            }
        }

        # Supports Locks
        if ($ColumnsToInclude -contains 'Locks') {
            if ([regex]::Match($moduleContentString, '(?m)^\s*param lock lockType').Success) {
                $summaryData.supportsLocks++
                $moduleDataItem['Locks'] = $true
            } else {
                $moduleDataItem['Locks'] = $false
            }
        }

        # Supports Tags
        if ($ColumnsToInclude -contains 'Tags') {
            if ([regex]::Match($moduleContentString, '(?m)^\s*param tags object\?').Success) {
                $summaryData.supportsTags++
                $moduleDataItem['Tags'] = $true
            } else {
                $moduleDataItem['Tags'] = $false
            }
        }

        # Supports Diagnostics
        if ($ColumnsToInclude -contains 'Diag') {
            if ([regex]::Match($moduleContentString, '(?m)^\s*param diagnosticSettings diagnosticSettingType').Success) {
                $summaryData.supportsDiagnostics++
                $moduleDataItem['Diag'] = $true
            } else {
                $moduleDataItem['Diag'] = $false
            }
        }

        # Supports Private Endpoints
        if ($ColumnsToInclude -contains 'PE') {
            if ([regex]::Match($moduleContentString, '(?m)^\s*param privateEndpoints privateEndpointType').Success) {
                $summaryData.supportsEndpoints++
                $moduleDataItem['PE'] = $true
            } else {
                $moduleDataItem['PE'] = $false
            }
        }

        # Supports PIPs
        if ($ColumnsToInclude -contains 'PIP') {
            if ([regex]::Match($moduleContentString, '(?m)^\s*param publicIPAddressObject object\s*=.+').Success) {
                $summaryData.supportsPipDeployment++
                $moduleDataItem['PIP'] = $true
            } else {
                $moduleDataItem['PIP'] = $false
            }
        }

        # Result
        $moduleData += $moduleDataItem
    }

    #######################
    #   Generate output   #
    #######################
    switch ($ReturnFormat) {
        'Object' {
            return @{
                data = $moduleData | ForEach-Object {
                    $resultObject = @{
                        Module = $_.Module
                    }
                    if ($ColumnsToInclude -contains 'Status') { $resultObject.Status = $_.Status }
                    if ($ColumnsToInclude -contains 'RBAC') { $resultObject.RBAC = $_.RBAC }
                    if ($ColumnsToInclude -contains 'Locks') { $resultObject.Locks = $_.Locks }
                    if ($ColumnsToInclude -contains 'Tags') { $resultObject.Tags = $_.Tags }
                    if ($ColumnsToInclude -contains 'Diag') { $resultObject.Diag = $_.Diag }
                    if ($ColumnsToInclude -contains 'PE') { $resultObject.PE = $_.PE }
                    if ($ColumnsToInclude -contains 'PIP') { $resultObject.PIP = $_.PIP }

                    # Return result
                    [PSCustomObject] $resultObject
                }
                sum  = $summaryData
            }
        }
        'Markdown' {
            $markdownTable = [System.Collections.ArrayList]@(
                '| # | {0} |' -f ($moduleData[0].Keys -join ' | ')
                '| - | {0} |' -f (($moduleData[0].Keys | ForEach-Object { '-' }) -join ' | ' )
            )

            # Format module identifier
            foreach ($module in $moduleData) {
                $identifierParts = $module.Module.Replace('\', '/').split('/')
                if ($identifierParts.Count -gt $BreakMarkdownModuleNameAt) {
                    $topLevelIdentifier = $identifierParts[0..($BreakMarkdownModuleNameAt - 1)] -join '/'
                    $module.Module = '{0}<p>{1}' -f $topLevelIdentifier, ($module.Module -replace "$topLevelIdentifier/", '')
                }
            }

            # Add table data
            $counter = 1
            foreach ($module in ($moduleData | Sort-Object { $_.Module })) {
                $line = '| {0} | {1} |' -f $counter, (($moduleData[0].Keys | ForEach-Object { $module[$_] }) -join ' | ')
                $line = $line -replace 'True', '✅'
                $line = $line -replace 'False', ''
                $line = $line -replace '\[\]', ''
                $markdownTable += $line
                $counter++
            }

            if ($summaryData.Keys.Count -gt 0) {
                $markdownTable += '| Sum | | | {0} |' -f (($summaryData.Keys | ForEach-Object { $summaryData[$_] }) -join ' | ')
            }
            return $markdownTable | Out-String
        }
        'CSV' {
            $csv = [System.Collections.ArrayList]@( ('#,{0}' -f ($moduleData[0].Keys -join ',') ))

            # Add CSV data
            $counter = 1
            foreach ($module in $moduleData) {
                $line = '{0},{1}' -f $counter, (($moduleData[0].Keys | ForEach-Object { $module[$_] }) -join ',')
                $line = $line -replace 'True', '✅'
                $line = $line -replace 'False', ''
                $line = $line -replace '\[\]', ''
                $csv += $line
                $counter++
            }
            if ($summaryData.Keys.Count -gt 0) {
                $csv += 'Sum,{0},{1}' -f (($summaryData.Keys -contains 'Status') ? ',' : ''), (($summaryData.Keys | ForEach-Object { $summaryData[$_] }) -join ',')
            }

            return $csv
        }
    }
}
