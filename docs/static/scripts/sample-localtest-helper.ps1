# Start pwsh if not started yet

pwsh

# Set default directory
$folder = "<your directory>/bicep-registry-modules"

# Dot source functions

. $folder/avm/utilities/tools/Set-AVMModule.ps1
. $folder/avm/utilities/tools/Test-ModuleLocally.ps1

# Variables

$modules = @(
    # "service-fabric/cluster", # Replace with your module
    "network/private-endpoint"  # Replace with your module
)

# Generate Readme

foreach ($module in $modules) {
    Write-Output "Generating ReadMe for module $module"
    Set-AVMModule -ModuleFolderPath "$folder/avm/res/$module" -Recurse

    # Set up test settings

    $testcases = "waf-aligned", "max", "defaults"

    $TestModuleLocallyInput = @{
        TemplateFilePath           = "$folder/avm/res/$module/main.bicep"
        ModuleTestFilePath         = "$folder/avm/res/$module/tests/e2e/max/main.test.bicep"
        PesterTest                 = $true
        ValidationTest             = $false
        DeploymentTest             = $false
        ValidateOrDeployParameters = @{
            Location         = '<your location>'
            SubscriptionId   = '<your subscriptionId>'
            RemoveDeployment = $true
        }
        AdditionalTokens           = @{
            namePrefix = '<your prefix>'
            TenantId   = '<your tenantId>'
        }
    }

    # Run tests

    foreach ($testcase in $testcases) {
        Write-Output "Running test case $testcase on module $module"
        $TestModuleLocallyInput.ModuleTestFilePath = "$folder/avm/res/$module/tests/e2e/$testcase/main.test.bicep"
        Test-ModuleLocally @TestModuleLocallyInput
    }
}
