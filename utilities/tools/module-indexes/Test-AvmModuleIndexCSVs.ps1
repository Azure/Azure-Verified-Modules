<#
.SYNOPSIS
    This script tests the Azure Verified Modules (AVM) module index CSV file for correctness and completeness.

.DESCRIPTION
    The Test-AvmModuleIndexCSVs.ps1 script is designed to validate the structure and content of the AVM module index CSV file.
    It checks for required columns and values, validates data formats, and ensures there are no missing or duplicate entries, etc.

    .PARAMETER CsvFilePath
    The path to the CSV file that needs to be tested.

.EXAMPLE
    .\Test-AvmModuleIndexCSVs.ps1
    This command runs the script on the default, pre-specified CSV files.

.EXAMPLE
    .\Test-AvmModuleIndexCSVs.ps1 -CsvFiles "C:\path\to\module-index.csv"
    This command runs the script on the CSV file provided in the input paramter.

.EXAMPLE
    .\Test-AvmModuleIndexCSVs.ps1 -CsvFiles "C:\path\to\module-index1.csv", C:\path\to\module-index2.csv"
    This command runs the script on the CSV files provided in the input paramter.
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Enter the full path to the CSV file.")]
    [ValidateNotNullOrEmpty()]
    [Alias("Path")]
    [array]$CsvFiles = @(
      $(Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName "docs" "static" "module-indexes" "BicepResourceModules.csv"),
      $(Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName "docs" "static" "module-indexes" "BicepPatternModules.csv"),
      $(Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName "docs" "static" "module-indexes" "BicepUtilityModules.csv"),
      $(Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName "docs" "static" "module-indexes" "TerraformResourceModules.csv"),
      $(Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName "docs" "static" "module-indexes" "TerraformPatternModules.csv"),
      $(Join-Path (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName "docs" "static" "module-indexes" "TerraformUtilityModules.csv")
    )
)

$RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName

$testFile = Join-Path $RepoRoot "utilities" "tools" "module-indexes" "module-index.tests.ps1"

foreach ($file in $csvFiles) {
  $pesterConfiguration = @{
    Run    = @{
      Container = New-PesterContainer -Path $testFile -Data @{
        CsvFilePath = $file
      }
      PassThru  = $true
    }
    Output = @{
      Verbosity = 'Detailed'
    }
  }
  Invoke-Pester -Configuration $pesterConfiguration
}
