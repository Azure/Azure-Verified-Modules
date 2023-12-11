
<#
.SYNOPSIS
Update the module features table in the given csv file path

.DESCRIPTION
Update the module features table in the given csv file path

.PARAMETER CSVFilePath
Mandatory. The path to the CSV file to update.

.PARAMETER ModulesFolderPath
Mandatory. The path to the modules folder.

.PARAMETER ModulesRepoRootPath
Mandatory. The path to the root of the repository containing the modules.

.EXAMPLE
Set-BicepModulesFeatureCSV -CSVFilePath 'docs/static/module-features/bicepFeatures.csv' -ModulesFolderPath 'bicep-registry-modules/avm' -ModulesRepoRootPath 'bicep-registry-modules'

Update the file 'bicepFeatures.csv' based on the modules in path 'bicep-registry-modules/avm'
#>
function Set-BicepModulesFeatureCSV {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $CSVFilePath,

        [Parameter(Mandatory)]
        [string] $ModulesFolderPath,

        [Parameter(Mandatory)]
        [string] $ModulesRepoRootPath
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesFeatureOutline.ps1')

    # Logic   
    $functionInput = @{
        ModulesFolderPath   = $ModulesFolderPath
        ModulesRepoRootPath = $ModulesRepoRootPath
        ReturnFormat        = 'CSV'
        OnlyTopLevel        = $true
        ColumnsToInclude    = @(      
            'RBAC',   
            'Locks',  
            'Tags',   
            'Diag',   
            'PE',     
            'PIP'    
        )
    }
    $featuresTable = Get-ModulesFeatureOutline @functionInput -Verbose

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($featuresTable | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$featuresTable]", 'Overwrite')) {
        Set-Item -Path $CSVFilePath -Value $featuresTable -Force
        Write-Verbose "File [$featuresTable] updated" -Verbose
    }
}
