
<#
.SYNOPSIS
Update the module features table in the given markdown file

.DESCRIPTION
Update the module features table in the given markdown file

.PARAMETER markdownFilePath
Mandatory. The path to the markdown file to update.

.PARAMETER moduleFolderPath
Mandatory. The path to the modules folder.

.PARAMETER RepositoryName
Mandatory. The name of the repository the code resides in. 

.PARAMETER Organization
Mandatory. The name of the Organization the code resides in.

.EXAMPLE
Set-ModuleFeaturesTable -markdownFilePath 'bicep-features-table.md' -moduleFolderPath 'bicep-registry-modules/avm/res'

Update the file 'bicep-features-table.md' based on the modules in path 'bicep-registry-modules/avm/res'
#>
function Set-ModuleFeaturesTable {

    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory)]
        [string] $markdownFilePath,

        [Parameter(Mandatory)]
        [string] $moduleFolderPath,

        [Parameter(Mandatory)]
        [string] $RepositoryName,

        [Parameter(Mandatory)]
        [string] $Organization
    )

    # Load external functions
    . (Join-Path $PSScriptRoot 'helper' 'Merge-FileWithNewContent.ps1')
    . (Join-Path $PSScriptRoot 'helper' 'Get-ModulesFeatureOutline.ps1')

    # Logic
    $originalContentArray = Get-Content -Path $markdownFilePath

    $functionInput = @{
        ModuleFolderPath = $moduleFolderPath
        ReturnMarkdown   = $true
        OnlyTopLevel     = $true
        AddStatusBadges  = $true
        RepositoryName   = $RepositoryName
        Organization     = $Organization
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
