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
    # [string]$CsvFilePath,

    # [Parameter(Mandatory = $false, Position = 1, HelpMessage = "Enter the IaC language (Bicep or Terraform).")]
    # [ValidateSet("Bicep", "Terraform")]
    # [string]$IacLanguage = "Bicep",

    [Parameter(Mandatory = $false)]
    [string] $RepoRoot = (Get-Item -Path $PSScriptRoot).parent.parent.parent.parent.FullName
)

# $RepoRoot
# $CsvFilePath

# try {
#     # Validate the CSV file path
#     if (-not (Test-Path -Path $CsvFilePath -PathType Leaf)) {
#         throw "The file path '$CsvFilePath' does not exist or is not a file."
#     }

#     # Read and process the CSV file
#     $csvContent = Import-Csv -Path $CsvFilePath

#     # Perform validation based on the IaC language
#     switch ($IacLanguage) {
#         "Bicep" {
#             # Add Bicep-specific validation logic here
#         }
#         "Terraform" {
#             # Add Terraform-specific validation logic here
#         }
#         default {
#             throw "Unsupported IaC language: $IacLanguage"
#         }
#     }

#     Write-Output "Validation completed successfully for $IacLanguage modules in the CSV file: $CsvFilePath"
# } catch {
#     Write-Error $_.Exception.Message

# }

# $csvContent
$testFiles = "$RepoRoot\Azure-Verified-Modules\utilities\tools\module-indexes\module-index.tests.ps1"
# $testFiles

$files =  @(
  'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\BicepResourceModules.csv',
  'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\BicepPatternModules.csv',
  'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\BicepUtilityModules.csv',
  'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\TerraformResourceModules.csv',
  'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\TerraformPatternModules.csv',
  'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\TerraformUtilityModules.csv'
)



foreach ($file in $files) {
  $pesterConfiguration = @{
    Run    = @{
      Container = New-PesterContainer -Path $testFiles -Data @{
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


# $pesterConfiguration = @{
#   Run    = @{
#     Container = New-PesterContainer -Path $testFiles -Data @{
#       CsvFilePath = 'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\BicepResourceModules.csv'
#     }
#     PassThru  = $false
#   }
#   Output = @{
#     Verbosity = 'Detailed'
#   }
# }
# Invoke-Pester -Configuration $pesterConfiguration

# $pesterConfiguration = @{
#   Run    = @{
#     Container = New-PesterContainer -Path $testFiles -Data @{
#       CsvFilePath = 'C:\SOURCE\Azure-Verified-Modules\docs\static\module-indexes\BicepPatternModules.csv'
#     }
#     PassThru  = $false
#   }
#   Output = @{
#     Verbosity = 'Detailed'
#   }
# }
# Invoke-Pester -Configuration $pesterConfiguration

# Invoke-Pester -Script "$RepoRoot\utilities\tools\module-indexes\Bicep.tests.ps1"

# $a = @()
# $params = @{
#   CsvFilePath = $CsvFilePath
#   IacLanguage = $IacLanguage
# }
# $a += @{Path =  "$RepoRoot\utilities\tools\module-indexes\Bicep.tests.ps1"; Parameters = $params}
# Invoke-Pester $a
# Invoke-Pester -PesterOption
