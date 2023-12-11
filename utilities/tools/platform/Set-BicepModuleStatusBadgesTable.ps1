
<#
.SYNOPSIS
Update the module features table in the given markdown file path

.DESCRIPTION
Update the module features table in the given markdown file path

.PARAMETER markdownFilePath
Mandatory. The path to the markdown file to update.

.PARAMETER ModulesFolderPath
Mandatory. The path to the modules folder.

.PARAMETER ModulesRepoRootPath
Mandatory. The path to the root of the repository containing the modules.

.EXAMPLE
Set-BicepModuleStatusBadgesTable -markdownFilePath 'bicepBadges.md' -ModulesFolderPath 'bicep-registry-modules/avm/res' -ModulesRepoRootPath 'bicep-registry-modules'

Update the file 'bicepBadges.md' based on the modules in path 'bicep-registry-modules/avm/res'
#>
function Set-BicepModuleStatusBadgesTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $markdownFilePath,

        [Parameter(Mandatory)]
        [string] $ModulesFolderPath,

        [Parameter(Mandatory)]
        [string] $ModulesRepoRootPath
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesFeatureOutline.ps1')
    
    $functionInput = @{
        ModulesFolderPath   = $ModulesFolderPath
        ModulesRepoRootPath = $ModulesRepoRootPath
        ReturnFormat        = 'Markdown'
        OnlyTopLevel        = $true
        ColumnsToInclude    = @( 'Status' )
    }
    $badgesMarkdown = Get-ModulesFeatureOutline @functionInput -Verbose

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($badgesMarkdown | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$markdownFilePath]", 'Overwrite')) {
        New-Item -Path $markdownFilePath -Value ($badgesMarkdown | Out-String) -Force
        Write-Verbose "File [$markdownFilePath] updated" -Verbose
    }
}
