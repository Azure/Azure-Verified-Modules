<#
.SYNOPSIS
    This script tests the Azure Verified Modules (AVM) module index CSV file for correctness and completeness.

.DESCRIPTION
    The Test-AvmModuleIndexCsv.ps1 script is designed to validate the structure and content of the AVM module index CSV file.
    It checks for required columns, validates data formats, and ensures there are no missing or duplicate entries.

.PARAMETER CsvFilePath
    The path to the CSV file that needs to be tested.

.PARAMETER IacLanguage
    The Infrastructure as Code (IaC) language for which the module index is being tested (Bicep or Terraform).

.EXAMPLE
    .\Test-AvmModuleIndexCsv.ps1 -CsvFilePath "C:\path\to\module-index.csv" -IacLanguage "Bicep"
    This command runs the script on the specified CSV file for the Bicep language and writes the results to the specified log file.

.EXAMPLE
    .\Test-AvmModuleIndexCsv.ps1 -CsvFilePath "C:\path\to\module-index.csv" -IacLanguage "Terraform"
    This command runs the script on the specified CSV file for the Terraform language and writes the results to the default log file.
#>

[CmdletBinding()]
param (
    # [Parameter(Mandatory = $false, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Enter the full path to the CSV file.")]
    # [ValidateNotNullOrEmpty()]
    # [Alias("Path")]
    # [string]$CsvFiles,

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
)

$testFile = "$RepoRoot\Azure-Verified-Modules\utilities\tools\module-indexes\module-index.tests.ps1"

$csvFiles =  @(
  "$RepoRoot\Azure-Verified-Modules\docs\static\module-indexes\BicepResourceModules.csv",
  "$RepoRoot\Azure-Verified-Modules\docs\static\module-indexes\BicepPatternModules.csv",
  "$RepoRoot\Azure-Verified-Modules\docs\static\module-indexes\BicepUtilityModules.csv",
  "$RepoRoot\Azure-Verified-Modules\docs\static\module-indexes\TerraformResourceModules.csv",
  "$RepoRoot\Azure-Verified-Modules\docs\static\module-indexes\TerraformPatternModules.csv",
  "$RepoRoot\Azure-Verified-Modules\docs\static\module-indexes\TerraformUtilityModules.csv"
)


foreach ($file in $csvFiles) {
  $pesterConfiguration = @{
    Run    = @{
      Container = New-PesterContainer -Path $testFile -Data @{
        CsvFilePath = $file
      }
      PassThru  = $false
    }
    Output = @{
      Verbosity = 'Detailed'
    }
  }
  Invoke-Pester -Configuration $pesterConfiguration
}
