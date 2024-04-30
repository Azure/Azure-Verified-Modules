
<#
.SYNOPSIS
Update the module features table in the given csv file path

.DESCRIPTION
Update the module features table in the given csv file path

.PARAMETER CSVFilePath
Mandatory. The path to the CSV file to update.

.PARAMETER ModulesRepoRootPath
Mandatory. The path to the root of the repository containing the modules.

.EXAMPLE
Set-BicepModulesFeatureCSV -CSVFilePath 'docs/static/module-features/bicepFeatures.csv' -ModulesRepoRootPath './bicep-registry-modules'

Update the file 'bicepFeatures.csv' based on the modules in path './bicep-registry-modules'
#>
function Set-BicepModulesFeatureCSV {

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '', Justification='For Join-Path it''s very difficult to read the cmdlet without positional parameters.')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $CSVFilePath,

        [Parameter(Mandatory)]
        [string] $ModulesRepoRootPath
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesFeatureOutline.ps1')

    # Logic
    $functionInput = @{
        ModulesFolderPath   = (Join-Path $ModulesRepoRootPath 'avm' 'res')
        ModulesRepoRootPath = $ModulesRepoRootPath
        ReturnFormat        = 'CSV'
        SearchDepth         = 2 # Only top level
        ColumnsToInclude    = @(
            'RBAC',
            'Locks',
            'Tags',
            'Diag',
            'PE',
            'CMK',
            'Identity'
        )
    }
    $featuresTable = Get-ModulesFeatureOutline @functionInput -Verbose

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($featuresTable | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$CSVFilePath]", 'Overwrite')) {
        New-Item -Path $CSVFilePath -Value ($featuresTable | Out-String) -Force
        Write-Verbose "File [$CSVFilePath] updated" -Verbose
    }
}
