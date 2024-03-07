<#
.SYNOPSIS
Parses AVM module CSV file

.DESCRIPTION
Depending on the parameter, the correct CSV file will be parsed and returned a an object

.PARAMETER ModuleIndex
Type of CSV file, that should be parsed ('Bicep-Resource', 'Bicep-Pattern')

.EXAMPLE
Next line will parse the AVM Bicep modules
Get-AvmCsvData -ModuleIndex 'Bicep-Resource'

#>
Function Get-AvmCsvData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string[]] $ModuleIndexURLs = @('https://aka.ms/avm/index/bicep/res/csv', 'https://aka.ms/avm/index/bicep/ptn/csv')
    )

    $formattedBicepFullCsv = @()

    foreach ($url in $ModuleIndexURLs) {
        try {
            $unfilteredCSV = Invoke-WebRequest -Uri $url
        }
        catch {
            Write-Error "Unable to retrieve CSV file - Check network connection."
        }

        # Convert the CSV content to a PowerShell object
        $formattedBicepFullCsv += ConvertFrom-CSV $unfilteredCSV.Content
    }

    # Loop through each item in the filtered data
    foreach ($item in $formattedBicepFullCsv) {
        # Remove '@Azure/' from the ModuleOwnersGHTeam property
        $item.ModuleOwnersGHTeam = $item.ModuleOwnersGHTeam -replace '@Azure/', ''
        # Remove '@Azure/' from the ModuleContributorsGHTeam property
        $item.ModuleContributorsGHTeam = $item.ModuleContributorsGHTeam -replace '@Azure/', ''
    }

    # Return the modified data
    return $formattedBicepFullCsv
}

<#
.SYNOPSIS
Creates a block of YAML entries based on a AVM CSV file

.DESCRIPTION
The function reads the AVM CSV file and converts all entries into a YAML file entries for the MCR bicep.yaml file. 

.PARAMETER ModuleIndex
Type of CSV file, that should be parsed ('Bicep-Resource', 'Bicep-Pattern')

.PARAMETER IndentFirstLine
Number of spaces to indent the first line of the YAML entry.

.PARAMETER IndentOtherLines
Number of spaces to indent the other lines of the YAML entry.

.EXAMPLE
New-ModuleYamlBlock -ModuleIndex Bicep-Resource -IndentFirstLine 2 -IndentOtherLines 4

.NOTES
The entries are sorted by the module name.
#>
function New-ModuleYamlBlock {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory=$false)]
        [int] $IndentFirstLine = 2,

        [Parameter(Mandatory=$false)]
        [int] $IndentOtherLines = 4
    )

    # Define the logo and support link
    $logoURL = 'https://raw.githubusercontent.com/Azure/bicep/main/src/vscode-bicep/icons/bicep-logo-256.png'
    $supportLink = 'https://github.com/Azure/bicep-registry-modules/issues'

    # Retrieve the CSV data and sort it by the module name
    $csvData = Get-AvmCsvData | Sort-Object -Property ModuleName

    # Create an array to store YAML entries
    $yamlEntries = @()

    # Iterate through each CSV entry and convert it to a YAML entry
    foreach ($csvLine in $csvData) {
        $yamlEntry = @'
{6}- name: public/bicep/{0}
{7}displayName: {1}
{7}description: {2}
{7}logoUrl: {3}
{7}supportLink: {4}
{7}documentationLink: {5}/README.md
'@
        $yamlEntries += $yamlEntry -f ($csvLine.ModuleName, $csvLine.ModuleDisplayName, $csvLine.Description, $logoURL, $supportLink, $csvLine.RepoURL, $(' ' * $IndentFirstLine), $(' ' * $IndentOtherLines)) + [Environment]::NewLine
    }

    # Return the YAML entries
    return $yamlEntries
}

<#
.SYNOPSIS
Creates the Bicep module YAML file in MCR

.DESCRIPTION
The function generates the MCR bicep.yaml file based on the AVM CSV files. It uses the New-ModuleYamlBlock function 
to create the YAML entries for the Bicep-Resource and Bicep-Pattern modules, then it composes the bicep.yaml file
and saves it to the specified location.

.PARAMETER OutputPath
The path where the bicep.yaml file should be saved.

.EXAMPLE
Set-MARManifest -OutputPath bicep.yml

.NOTES
The entries are sorted by the full module name.
#>
function Set-MARManifest {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $OutputPath = $(Join-Path $PSScriptRoot 'bicep.yml')
    )

    # Retrieve the converted YAML entries for the Bicep-Resource and Bicep-Pattern modules
    $yamlEntriesRes = New-ModuleYamlBlock 

    # Constructing the output file content
    # Adding the header file to the output file content
    $headerFilePath = Join-Path $PSScriptRoot 'src' 'manifestHeader.yml'
    if (-not (Test-Path $headerFilePath)) {
        Write-Error "The header file [$headerFilePath] does not exist."
    }

    # Adding the header file content to the output file content
    $outputFileContent = Get-Content -Path $headerFilePath

    # Adding the Bicep-Resource YAML entries to the output file content
    $outputFileContent += $yamlEntriesRes

    # Save the output file
    $outputFileContent | Out-File -FilePath $OutputPath -Force
}

Set-MARManifest