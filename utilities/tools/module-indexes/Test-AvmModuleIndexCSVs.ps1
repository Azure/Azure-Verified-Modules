<#
.SYNOPSIS
    This script tests the Azure Verified Modules (AVM) module index CSV file for correctness and completeness.

.DESCRIPTION
    The Test-AvmModuleIndexCSVs.ps1 script is designed to validate the structure and content of the AVM module index CSV file.
    It checks for required columns and values, validates data formats, and ensures there are no missing or duplicate entries, etc.

.EXAMPLE
    .\Test-AvmModuleIndexCSVs.ps1
    This command runs the script on the pre-specified CSV files.
#>

$RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.FullName

$testFile = Join-Path $RepoRoot "utilities" "tools" "module-indexes" "module-index.tests.ps1"


$csvFiles =  @(
  $(Join-Path $RepoRoot "docs" "static" "module-indexes" "BicepResourceModules.csv"),
  $(Join-Path $RepoRoot "docs" "static" "module-indexes" "BicepPatternModules.csv"),
  $(Join-Path $RepoRoot "docs" "static" "module-indexes" "BicepUtilityModules.csv"),
  $(Join-Path $RepoRoot "docs" "static" "module-indexes" "TerraformResourceModules.csv"),
  $(Join-Path $RepoRoot "docs" "static" "module-indexes" "TerraformPatternModules.csv"),
  $(Join-Path $RepoRoot "docs" "static" "module-indexes" "TerraformUtilityModules.csv")
)

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
