
<#
.SYNOPSIS
Update the module features table in the given markdown file path

.DESCRIPTION
Update the module features table in the given markdown file path

.PARAMETER markdownFilePath
Mandatory. The path to the markdown file to update.

.PARAMETER ModulesRepoRootPath
Mandatory. The path to the root of the repository containing the modules.

.EXAMPLE
Set-BicepModuleStatusBadgesTable -markdownFilePath 'bicepBadges.md' -ModulesRepoRootPath './bicep-registry-modules'

Update the file 'bicepBadges.md' based on the modules in path './bicep-registry-modules'
#>
function Set-BicepModuleStatusBadgesTable {

    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingPositionalParameters', '', Justification='For Join-Path it''s very difficult to read the cmdlet without positional parameters.')]
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $markdownFilePath,

        [Parameter(Mandatory)]
        [string] $ModulesRepoRootPath
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesFeatureOutline.ps1')

    $functionInput = @{
        ModulesFolderPath   = (Join-Path $ModulesRepoRootPath 'avm')
        ModulesRepoRootPath = $ModulesRepoRootPath
        ReturnFormat        = 'Markdown'
        SearchDepth         = 3 # Only top level
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
