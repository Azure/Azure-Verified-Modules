<#
.SYNOPSIS
Get an outline of all modules features for each module contained in the given path

.DESCRIPTION
Get a list of objects that outline of all modules features for each module contained in the given path (for example child-modules, RBAC, Private Endpoints, etc.)

NOTE: Currently only supports modules using the Bicep DSL

.PARAMETER ModuleFolderPath
Optional. The path to the modules.

.PARAMETER ReturnMarkdown
Optional. Instead of returning the list of objects, instead format them into a markdown table and return it as a string.

.PARAMETER BreakMarkdownModuleNameAt
Optional. When `ReturnMarkdown` is set to true you can use this number to control if & where you'd want to line break the ModuleName column. Defaults to 1 (i.e., right after the provider namepsace).

.PARAMETER OnlyTopLevel
Optional. Only consider top-level modules (that is, no child-modules).

.PARAMETER AddStatusBadges
Optional. Add status badges for top-level modules as a column

.PARAMETER RepositoryName
Optional. The name of the repository the code resides in. Required if 'AddStatusBadges' is 'true'

.PARAMETER Organization
Optional. The name of the Organization the code resides in. Required if 'AddStatusBadges' is 'true'

.EXAMPLE
Get-ModulesFeatureOutline

Get an outline of all modules in the default module path.

.EXAMPLE
Get-ModulesFeatureOutline -ReturnMarkdown -OnlyTopLevel

Get an outline of top-level modules in the default module path, formatted in a markdown table.

.EXAMPLE
Get-ModulesFeatureOutline -ReturnMarkdown -BreakMarkdownModuleNameAt 2

Get an outline of all modules in the default module path, formatted in a markdown table - with the module name column split after the top-level (i.e., <ProviderNamespace>/<ResourceType)

.EXAMPLE
Get-ModulesFeatureOutline -ReturnMarkdown -BreakMarkdownModuleNameAt 2 -AddStatusBadges -RepositoryName 'ResourceModules' -Organization 'Azure'

Get an outline of all modules in the default module path, formatted in a markdown table - with the module name column split after the top-level (i.e., <ProviderNamespace>/<ResourceType). Further, include the status badges for GitHub into the table.

.NOTES
Children (if any) are displayed in format `[L1:5, L2:4, L3:1]`. Each item (separated via ',') shows the level of nesting in the front (e.g. L1) and the number of children in this level (separated by a colon ':').
In the above example, the module has 5 direct children, 4 of them have direct children themselves and 1 of them has 1 more child.
#>
function Get-ModulesFeatureOutline {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string] $ModuleFolderPath = (Join-Path (Split-Path (Split-Path $PSScriptRoot -Parent) -Parent) 'modules'),

        [Parameter(Mandatory = $false)]
        [switch] $ReturnMarkdown,

        [Parameter(Mandatory = $false)]
        [int] $BreakMarkdownModuleNameAt = 1,

        [Parameter(Mandatory = $false)]
        [switch] $OnlyTopLevel,

        [Parameter(Mandatory = $false)]
        [switch] $AddStatusBadges,

        [Parameter(Mandatory = $false)]
        [string] $RepositoryName,

        [Parameter(Mandatory = $false)]
        [string] $Organization
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'Get-PipelineStatusUrl.ps1')

    if ($OnlyTopLevel) {
        $moduleTemplatePaths = (Get-ChildItem $ModuleFolderPath -Recurse -Filter 'main.bicep' -Depth 2).FullName
    } else {
        $moduleTemplatePaths = (Get-ChildItem $ModuleFolderPath -Recurse -Filter 'main.bicep').FullName
    }

    ####################
    #   Collect data   #
    ####################
    $moduleData = [System.Collections.ArrayList]@()
    $summaryData = [ordered]@{
        supportsRBAC          = 0
        supportsLocks         = 0
        supportsTags          = 0
        supportsDiagnostics   = 0
        supportsEndpoints     = 0
        supportsPipDeployment = 0
        numberOfChildren      = 0
        numberOfLines         = 0
    }
    foreach ($moduleTemplatePath in $moduleTemplatePaths) {

        $fullResourcePath = (((Split-Path $moduleTemplatePath -Parent) -replace '\\', '/') -split '/modules/')[1]
        $moduleContentArray = Get-Content -Path $moduleTemplatePath
        $moduleContentString = Get-Content -Path $moduleTemplatePath -Raw

        $moduleDataItem = [ordered]@{
            Module = $fullResourcePath
        }

        # Status Badge
        $isTopLevelModule = ($fullResourcePath -split '/').Count -eq 2
        if ($AddStatusBadges -and $isTopLevelModule) {

            $moduleIdentifier = (Split-Path $fullResourcePath -Parent) -split '[\/|\\](avm[\/|\\])'
            $specsAlignedResourceName = ($moduleIdentifier[1, 2] -join '') -replace '\\', '/'

            $provider = ($specsAlignedResourceName -split '/')[0]
            $resourceType = ($specsAlignedResourceName -split '/')[1]

            $statusInputObject = @{
                RepositoryName     = $RepositoryName
                Organization       = $Organization
                PipelineFileName   = ((('{0}.{1}.yml' -f $provider, $resourceType) -replace '-', '') -replace '/', '.')
                PipelineFolderPath = Join-Path '.github' 'workflows'
            }

            $moduleDataItem['Status'] = Get-PipelineStatusUrl @statusInputObject
        }

        # Supports RBAC
        if ([regex]::Match($moduleContentString, '(?m)^\s*param roleAssignments roleAssignmentType').Success) {
            $summaryData.supportsRBAC++
            $moduleDataItem['RBAC'] = $true
        } else {
            $moduleDataItem['RBAC'] = $false
        }

        # Supports Locks
        if ([regex]::Match($moduleContentString, '(?m)^\s*param lock lockType').Success) {
            $summaryData.supportsLocks++
            $moduleDataItem['Locks'] = $true
        } else {
            $moduleDataItem['Locks'] = $false
        }

        # Supports Tags
        if ([regex]::Match($moduleContentString, '(?m)^\s*param tags object\?').Success) {
            $summaryData.supportsTags++
            $moduleDataItem['Tags'] = $true
        } else {
            $moduleDataItem['Tags'] = $false
        }

        # Supports Diagnostics
        if ([regex]::Match($moduleContentString, '(?m)^\s*param diagnosticSettings diagnosticSettingType').Success) {
            $summaryData.supportsDiagnostics++
            $moduleDataItem['Diag'] = $true
        } else {
            $moduleDataItem['Diag'] = $false
        }

        # Supports Private Endpoints
        if ([regex]::Match($moduleContentString, '(?m)^\s*param privateEndpoints privateEndpointType').Success) {
            $summaryData.supportsEndpoints++
            $moduleDataItem['PE'] = $true
        } else {
            $moduleDataItem['PE'] = $false
        }

        # Supports PIPs
        if ([regex]::Match($moduleContentString, '(?m)^\s*param publicIPAddressObject object\s*=.+').Success) {
            $summaryData.supportsPipDeployment++
            $moduleDataItem['PIP'] = $true
        } else {
            $moduleDataItem['PIP'] = $false
        }

        # Number of children
        $childFolderPaths = (Get-ChildItem -Path (Split-Path $moduleTemplatePath -Parent) -Recurse -Directory).FullName | Where-Object { $_ -and (Split-Path $_ -Leaf) -match '^\w+' }
        $levelsOfNesting = @()
        foreach ($childFolderPath in $childFolderPaths) {
            $simplifiedPath = $childFolderPath.Replace('\', '/').split("$fullResourcePath/")[1]
            $levelsOfNesting += ($simplifiedPath -split '/').Count
        }
        $groupedNesting = $levelsOfNesting | Group-Object | Sort-Object -Property 'Name'
        $numberOfChildrenFormatted = '[{0}]' -f (($groupedNesting | ForEach-Object { 'L{0}:{1}' -f $_.Name, $_.Count }) -join ', ')
        $moduleDataItem['# children'] = $numberOfChildrenFormatted
        $groupedNesting | ForEach-Object { $summaryData.numberOfChildren += $_.Count }

        # Number of lines
        $numberOfLines = ($moduleContentArray | Where-Object { -not [String]::IsNullOrEmpty($_) }).Count + 1
        $summaryData.numberOfLines += $numberOfLines
        $moduleDataItem['# lines'] = $numberOfLines

        # Result
        $moduleData += $moduleDataItem
    }

    #######################
    #   Generate output   #
    #######################
    if ($ReturnMarkdown) {
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
            $line = $line -replace 'True', ':white_check_mark:'
            $line = $line -replace 'False', ''
            $line = $line -replace '\[\]', ''
            $markdownTable += $line
            $counter++
        }

        $markdownTable += '| Sum | | | {0} |' -f (($summaryData.Keys | ForEach-Object { $summaryData[$_] }) -join ' | ')

        return $markdownTable | Out-String

    } else {
        return @{
            data = $moduleData | ForEach-Object {
                [PSCustomObject] @{
                    Module       = $_.Module
                    'RBAC'       = $_.'RBAC'
                    'Locks'      = $_.'Locks'
                    'Tags'       = $_.'Tags'
                    'Diag'       = $_.'Diag'
                    'PE'         = $_.'PE'
                    'PIP'        = $_.'PIP'
                    '# children' = $_.'# children'
                    '# lines'    = $_.'# lines'
                }
            }
            sum  = $summaryData
        }
    }
}
