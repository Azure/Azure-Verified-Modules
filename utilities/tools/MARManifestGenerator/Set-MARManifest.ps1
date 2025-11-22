<#
.SYNOPSIS
Creates the Bicep module YAML file in MCR

.DESCRIPTION
The function generates the MCR bicep.yaml file based on the AVM CSV files. It uses the Get-ModuleYamlBlock function
to create the YAML entries for the Bicep-Resource and Bicep-Pattern modules, then it composes the bicep.yaml file
and saves it to the specified location.

.PARAMETER OutputFile
The path where the bicep.yaml file should be saved.

.EXAMPLE
Set-MARManifest -OutputFile bicep.yml

.NOTES
The entries are sorted by the full module name.
#>
Function Set-MARManifest {
    [CmdletBinding(SupportsShouldProcess)]
    param (
        [Parameter(Mandatory = $false)]
        [string] $OutputFile = $(Join-Path $PSScriptRoot 'bicep.yml')
    )

    # Retrieve the converted YAML entries for the Bicep-Resource and Bicep-Pattern modules
    $yamlEntries = Get-ModuleYamlBlock

    # Constructing the output file content
    # Adding the header file to the output file content
    $headerFilePath = Join-Path -Path $PSScriptRoot -ChildPath 'manifestHeader.yml'
    if (-not (Test-Path $headerFilePath)) {
        Write-Error "The header file [$headerFilePath] does not exist."
    }

    # Adding the header file content to the output file content
    $outputFileContent = Get-Content -Path $headerFilePath

    # Adding the Bicep-Resource YAML entries to the output file content
    $outputFileContent += $yamlEntries

    # Save the output file
    $outputFileContent | Out-File -FilePath $OutputFile -Force
}

<#
.SYNOPSIS
Parses AVM module CSV files

.DESCRIPTION
The CSV files will be parsed and returned a an object

.PARAMETER ModuleIndexURLs
Array the URLs, where module CSV files for Resource and Pattern modules are stored

.EXAMPLE
Get-AvmCsvData -ModuleIndexURLs 'https://example.com/url3', 'https://example.com/url4'

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

.PARAMETER logoURL
URL to the logo image for all modules.

.PARAMETER supportLink
URL to the support page for all modules.

.PARAMETER IndentFirstLine
Number of spaces to indent the first line of the YAML entry.

.PARAMETER IndentOtherLines
Number of spaces to indent the other lines of the YAML entry.

.EXAMPLE
Get-ModuleYamlBlock -ModuleIndex Bicep-Resource -IndentFirstLine 2 -IndentOtherLines 4

.NOTES
The entries are sorted by the module name.
#>
Function Get-ModuleYamlBlock {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string] $logoURL = 'https://raw.githubusercontent.com/Azure/bicep/main/src/vscode-bicep/icons/bicep-logo-256.png',

        [Parameter(Mandatory=$false)]
        [string] $supportLink = 'https://github.com/Azure/bicep-registry-modules/issues',

        [Parameter(Mandatory=$false)]
        [int] $IndentFirstLine = 2,

        [Parameter(Mandatory=$false)]
        [int] $IndentOtherLines = 4
    )

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
        if ($csvLine -ne $csvData[-1]) { # Add a newline between entries, except for the last one
            $yamlEntries += $yamlEntry -f ($csvLine.ModuleName, $csvLine.ModuleDisplayName, $csvLine.Description, $logoURL, $supportLink, $csvLine.RepoURL, $(' ' * $IndentFirstLine), $(' ' * $IndentOtherLines)) + [Environment]::NewLine
        }
        else {
            $yamlEntries += $yamlEntry -f ($csvLine.ModuleName, $csvLine.ModuleDisplayName, $csvLine.Description, $logoURL, $supportLink, $csvLine.RepoURL, $(' ' * $IndentFirstLine), $(' ' * $IndentOtherLines))
        }
    }

    # Return the YAML entries
    return $yamlEntries
}
