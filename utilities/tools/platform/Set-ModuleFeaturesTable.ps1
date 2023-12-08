
<#
.SYNOPSIS
Update the module features table in the given markdown file

.DESCRIPTION
Update the module features table in the given markdown file

.PARAMETER markdownFilePath
Mandatory. The path to the markdown file to update.

.PARAMETER ModulesFolderPath
Mandatory. The path to the modules folder.

.PARAMETER ModulesRepoRootPath
Mandatory. The path to the root of the repository containing the modules.

.EXAMPLE
Set-ModuleFeaturesTable -markdownFilePath 'bicep-features-table.md' -ModulesFolderPath 'bicep-registry-modules/avm/res' -ModulesRepoRootPath 'bicep-registry-modules'

Update the file 'bicep-features-table.md' based on the modules in path 'bicep-registry-modules/avm/res'
#>
function Set-ModuleFeaturesTable {

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
    . (Join-Path $PSScriptRoot 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesFeatureOutline.ps1')

    # Logic
    if(-not (Test-Path -Path $markdownFilePath)) {
        $null = New-Item -Path $markdownFilePath -ItemType 'File'
    } 
    $originalContentArray = Get-Content -Path $markdownFilePath
    
    $functionInput = @{
        ModulesFolderPath   = $ModulesFolderPath
        ModulesRepoRootPath = $ModulesRepoRootPath
        ReturnMarkdown      = $true
        OnlyTopLevel        = $true
        AddStatusBadges     = $true
    }
    $featureTableString = Get-ModulesFeatureOutline @functionInput -Verbose

    $newContent = Merge-FileWithNewContent -oldContent $originalContentArray -newContent $featureTableString.TrimEnd() -sectionStartIdentifier '# Feature table' -contentType 'table'

    Write-Verbose 'New content:'
    Write-Verbose '============'
    Write-Verbose ($newContent | Out-String)

    if ($PSCmdlet.ShouldProcess("File in path [$markdownFilePath]", 'Overwrite')) {
        Set-Content -Path $markdownFilePath -Value $newContent -Force
        Write-Verbose "File [$markdownFilePath] updated" -Verbose
    }
}
