[CmdletBinding()]
param (
    [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = 'Enter the full path to the CSV file.')]
    [ValidateNotNullOrEmpty()]
    [Alias('Path')]
    [string]$CsvFilePath
)

BeforeAll {
    $csvContent = Import-Csv -Path $CsvFilePath
    $rawFile = Get-Content -Path $CsvFilePath
    $csvHeaders = $csvContent[0].PSObject.Properties.Name

    $issues = & gh issue list --limit 99999 --state all --json title,body | ConvertFrom-Json

    $singularExceptions = @(
        'redis',
        'address',
        'publicipaddress'
    )

}

Describe "Tests for the $(Split-Path $CsvFilePath -Leaf) file" {

    Context 'CSV file' {

        It 'CSV file must not be empty' {
            $csvContent | Should -Not -BeNullOrEmpty
        }

        if ($CsvFilePath -match 'ResourceModules') {
            It 'Should contain exactly the columns required for resource modules' {
                $requiredColumns = @(
                    'ProviderNamespace', 'ResourceType', 'ModuleDisplayName', 'ModuleName', 'ModuleStatus',
                    'RepoURL', 'PublicRegistryReference', 'TelemetryIdPrefix', 'PrimaryModuleOwnerGHHandle',
                    'PrimaryModuleOwnerDisplayName', 'SecondaryModuleOwnerGHHandle', 'SecondaryModuleOwnerDisplayName',
                    'ModuleOwnersGHTeam', 'ModuleContributorsGHTeam', 'Description', 'Comments', 'FirstPublishedIn'
                )
                $csvHeaders | Should -Be $requiredColumns
            }
        } elseif ($CsvFilePath -match 'PatternModules') {
            It 'Should contain exactly the columns required for pattern modules' {
                $requiredColumns = @(
                    'ModuleDisplayName', 'ModuleName', 'ModuleStatus',
                    'RepoURL', 'PublicRegistryReference', 'TelemetryIdPrefix', 'PrimaryModuleOwnerGHHandle',
                    'PrimaryModuleOwnerDisplayName', 'SecondaryModuleOwnerGHHandle', 'SecondaryModuleOwnerDisplayName',
                    'ModuleOwnersGHTeam', 'ModuleContributorsGHTeam', 'Description', 'Comments', 'FirstPublishedIn'
                )
                $csvHeaders | Should -Be $requiredColumns
            }
        } elseif ($CsvFilePath -match 'UtilityModules') {
            It 'Should contain exactly the columns required for pattern modules' {
                $requiredColumns = @(
                    'ModuleDisplayName', 'ModuleName', 'ModuleStatus',
                    'RepoURL', 'PublicRegistryReference', 'TelemetryIdPrefix', 'PrimaryModuleOwnerGHHandle',
                    'PrimaryModuleOwnerDisplayName', 'SecondaryModuleOwnerGHHandle', 'SecondaryModuleOwnerDisplayName',
                    'ModuleOwnersGHTeam', 'ModuleContributorsGHTeam', 'Description', 'Comments', 'FirstPublishedIn'
                )
                $csvHeaders | Should -Be $requiredColumns
            }
        }

        It 'Should have at least 1 record' {
            $csvContent.Length | Should -BeGreaterOrEqual 1
        }

        It 'Should not have any trailing white spaces in any value' {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                foreach ($column in $csvHeaders) {
                    $item.$column | Should -Not -Match '\s+$' -Because "there should not be any trailing white spaces in the ""$column"" column, in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should not have any leading white spaces in any value' {
            $lineNumber = 1
            foreach ($line in $rawFile) {
                $line | Should -Not -Match '^\s+|,\s+' -Because "there should not be any leading white spaces anywhere in line #$lineNumber"
                $lineNumber++
            }
        }


    }

    Context 'ModuleDisplayName column' {

        It "Should not have any missing values in the 'ModuleDisplayName' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.ModuleDisplayName | Should -Not -BeNullOrEmpty -Because "ModuleDisplayName is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'ModuleDisplayName' column" {
            $duplicates = $csvContent | Group-Object -Property ModuleDisplayName | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's ModuleDisplayName should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }
    }

    Context 'ModuleName column' {
        It "Should not have any missing values in the 'ModuleName' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.ModuleName | Should -Not -BeNullOrEmpty -Because "ModuleName is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'ModuleName' column" {
            $duplicates = $csvContent | Group-Object -Property ModuleName | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's ModuleName should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }

        if ($CsvFilePath -match 'Bicep') {

            It "Should only contain allowed characters" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $item.ModuleName | Should -Match '^[a-z0-9]+(?:[\/-][a-z0-9]+)*$' -Because "each segment of ModuleName should only contain lowercase letters, numbers and hyphens, in line #$lineNumber"
                    $lineNumber++
                }
            }

            if ($CsvFilePath -match 'ResourceModules') {
                It "Should start with 'avm/res/'" {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.ModuleName | Should -Match '^avm/res/.*' -Because "ModuleName should start with 'avm/res/'. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }

                It 'First segment of ModuleName should be derived from the ProviderNamespace' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $firstSegmentFromRP = ($item.ProviderNamespace -replace 'Microsoft.', '' -replace '\.', '').ToLower()
                        $firstSegmentInModuleName = ($item.ModuleName -split '/')[2] -replace '-', ''
                        $firstSegmentInModuleName | Should -BeLike "$firstSegmentFromRP" -Because "the first segment of ModuleName should be derived from the ProviderNamespace. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }

                It 'Second segment of ModuleName should be derived from the ResourceType' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $resourceType = $item.ResourceType.ToLower()
                        $secondSegmentOfModuleName = (($item.ModuleName -split '/')[-1] -replace '-', '').ToLower()

                        if ($resourceType -notmatch 's$') {
                            $secondSegmentOfModuleName | Should -Be $resourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        } elseif ($resourceType -match 'ies$') {
                            $rootOfResourceType = $resourceType.Substring(0, $resourceType.Length - 3)
                            $secondSegmentOfModuleName | Should -Match $rootOfResourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        } elseif ($resourceType -match 'es$') {
                            $rootOfResourceType = $resourceType.Substring(0, $resourceType.Length - 2)
                            $secondSegmentOfModuleName | Should -Match $rootOfResourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        } elseif ($resourceType -match 's$') {
                            $rootOfResourceType = $resourceType.Substring(0, $resourceType.Length - 1)
                            $secondSegmentOfModuleName | Should -Match $rootOfResourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        }
                        $lineNumber++
                    }
                }

                It 'Second segment of ModuleName should be in singular form' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {

                        $lastWord = (($item.ModuleName -split '/')[-1] -split '-')[-1]
                        if ($lastWord -notin $singularExceptions) {
                            $item.ModuleName | Should -Not -Match 's$' -Because "ModuleName should be in singular form. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        }
                        $lineNumber++
                    }
                }

            } elseif ($CsvFilePath -match 'PatternModules') {
                It "Should start with 'avm/ptn/'" {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.ModuleName | Should -Match '^avm/ptn/.*' -Because "ModuleName should start with 'avm/ptn/'. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }

                It 'Should have exactly 2 segments (after the prefix)' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $truncatedModuleName = $item.ModuleName -replace 'avm/ptn/', ''
                        $truncatedModuleName -split '/' | Should -HaveCount 2 -Because "ModuleName should have exactly 2 segments in line #$lineNumber"
                        $lineNumber++
                    }
                }
            } elseif ($CsvFilePath -match 'UtilityModules') {
                It "Should start with 'avm/utl/'" {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.ModuleName | Should -Match '^avm/utl/.*' -Because "ModuleName should start with 'avm/utl/'. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }

                It 'Should have exactly 2 segments (after the prefix)' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $truncatedModuleName = $item.ModuleName -replace 'avm/utl/', ''
                        $truncatedModuleName -split '/' | Should -HaveCount 2 -Because "ModuleName should have exactly 2 segments in line #$lineNumber"
                        $lineNumber++
                    }
                }
            }

            It "All items in the CSV should be alphabetically ordered, based on ModuleName" {

                # Set-ItResult -Skipped

                # $moduleNames = $csvContent.ModuleName
                # $sortedModuleNames = $moduleNames | Sort-Object -Stable -Culture "en-US"
                # for ($i = 0; $i -lt $moduleNames.Length; $i++) {
                #     $moduleNames[$i] | Should -Be $sortedModuleNames[$i] -Because "All items in the CSV should be alphabetically ordered, based on ModuleName"
                # }

                # $moduleNames = $csvContent.ModuleName
                # $normalizedModuleNames = $moduleNames -replace '[/\-]', ''
                # $sortedModuleNames = $normalizedModuleNames | Sort-Object -Stable -Culture "en-US"

                # for ($i = 0; $i -lt $moduleNames.Length; $i++) {
                #     $normalizedModuleNames[$i] | Should -Be $sortedModuleNames[$i] -Because "All items in the CSV should be alphabetically ordered, based on normalized ModuleName"
                # }

                $normalizedModuleNames = @()
                $moduleNames = @($csvContent.ModuleName -replace '-', '')

                foreach ($moduleName in $moduleNames) {

                    $segments = $moduleName -split "/"

                    $obj = [PSCustomObject]@{
                        prefix = $segments[0] + "/" + $segments[1] + "/"
                        firstSegment  = $segments[2]
                        secondSegment = $segments[3]
                    }

                    $normalizedModuleNames += $obj
                }

                $customSortedModuleNames = $normalizedModuleNames | Sort-Object -Property firstSegment, secondSegment
                $results = @()
                foreach ($item in $customSortedModuleNames){
                    $results +=  $item.prefix + $item.firstSegment + "/" + $item.secondSegment
                }

                for ($i = 0; $i -lt $moduleNames.Length; $i++) {
                    $moduleNames[$i] | Should -Be $results[$i] -Because "All items in the CSV should be alphabetically ordered, based on ModuleName"
                }
            }

        } elseif ($CsvFilePath -match 'Terraform') {

            It "Should only contain allowed characters" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $item.ModuleName | Should -Match '^[a-z0-9]+(?:[-][a-z0-9]+)*$' -Because "each segment of ModuleName should only contain lowercase letters and numbers, in line #$lineNumber"
                    $lineNumber++
                }
            }

            if ($CsvFilePath -match 'ResourceModules') {
                It "Should start with 'avm-res-'" {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.ModuleName | Should -Match '^avm-res-.*' -Because "ModuleName should start with 'avm-res-'. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }

                It 'Should have exactly 2 segments (after the prefix)' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $truncatedModuleName = $item.ModuleName -replace 'avm-res-', ''
                        $truncatedModuleName -split '-' | Should -HaveCount 2 -Because "ModuleName should have exactly 2 segments in line #$lineNumber"
                        $lineNumber++
                    }
                }

                It 'First segment of ModuleName should be derived from the ProviderNamespace' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $firstSegmentFromRP = ($item.ProviderNamespace -replace 'Microsoft.', '' -replace '\.', '').ToLower()
                        $firstSegmentInModuleName = ($item.ModuleName -split '-')[2]
                        $firstSegmentInModuleName | Should -BeLike "$firstSegmentFromRP" -Because "the first segment of ModuleName should be derived from the ProviderNamespace. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }

                It 'Second segment of ModuleName should be derived from the ResourceType' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $resourceType = $item.ResourceType.ToLower()
                        $secondSegmentOfModuleName = (($item.ModuleName -split '-')[-1]).ToLower()

                        if ($resourceType -notmatch 's$') {
                            $secondSegmentOfModuleName | Should -Be $resourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        } elseif ($resourceType -match 'ies$') {
                            $rootOfResourceType = $resourceType.Substring(0, $resourceType.Length - 3)
                            $secondSegmentOfModuleName | Should -Match $rootOfResourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        } elseif ($resourceType -match 'es$') {
                            $rootOfResourceType = $resourceType.Substring(0, $resourceType.Length - 2)
                            $secondSegmentOfModuleName | Should -Match "^$($rootOfResourceType).*" -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        } elseif ($resourceType -match 's$') {
                            $rootOfResourceType = $resourceType.Substring(0, $resourceType.Length - 1)
                            $secondSegmentOfModuleName | Should -Match $rootOfResourceType -Because "the second segment of ModuleName should be derived from the ResourceType in line #$lineNumber"
                        }
                        $lineNumber++
                    }
                }

                It 'Second segment of ModuleName should be in singular form' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {

                        $lastWord = ($item.ModuleName -split '-')[-1]
                        if ($lastWord -notin $singularExceptions) {
                            $item.ModuleName | Should -Not -Match 's$' -Because "ModuleName should be in singular form. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        }
                        $lineNumber++
                    }
                }


            } elseif ($CsvFilePath -match 'PatternModules') {
                It "Should start with 'avm-ptn-'" {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.ModuleName | Should -Match '^avm-ptn-.*' -Because "ModuleName should start with 'avm-ptn-'. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }
            } elseif ($CsvFilePath -match 'UtilityModules') {
                It "Should start with 'avm-utl-'" {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.ModuleName | Should -Match '^avm-utl-.*' -Because "ModuleName should start with 'avm-utl-'. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item.ModuleName)"""
                        $lineNumber++
                    }
                }
            }

        }

        It 'Should have a related "Module Proposal" issue in the AVM repo' {

            foreach ($item in $csvContent) {
                $moduleName = $item.ModuleName
                $issueExists = $false

                foreach ($issue in $issues) {
                    if ($issue.title -match "[Module Proposal]*``$moduleName``" ) {
                        $issueExists = $true
                        break
                    }
                }
                $issueExists | Should -Be $true -Because "there should be a GitHub issue that starts with ""[Module Proposal]"" and contains the ModuleName ""$moduleName"" between backticks,"
            }
        }

        It 'Should be captured in the related Module Proposal issue, under the "### Module Name" section' {
            foreach ($item in $csvContent) {
                $moduleName = $item.ModuleName
                $nameCorrectInBody = $false

                foreach ($issue in $issues) {
                    if ($issue.title -match "[Module Proposal]*``$moduleName``" ) {
                        if ($issue.body -match "### Module Name\s*\r?\n\r?\n$moduleName" ) {
                            $nameCorrectInBody = $true
                            break
                        }

                    }
                }
                $nameCorrectInBody | Should -Be $true -Because "ModuleName (""$moduleName"") should be captured in the GitHub issue under the ""### Module Name"" section"
            }
        }


    }

    Context 'ModuleStatus column' {
        It "Should have a valid value in the 'ModuleStatus' column" {
            $allowedValues = @(
                'Proposed :new:', 'Available :green_circle:', 'Orphaned :eyes:'
            )
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.ModuleStatus | Should -BeIn $allowedValues -Because "ModuleStatus should be one of the following: 'Proposed :new:', 'Available :green_circle:', 'Orphaned :eyes:'. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.ModuleStatus)"""
                $lineNumber++
            }
        }

    }

    Context 'RepoURL column' {
        It "Should not have any missing values in the 'RepoURL' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.RepoURL | Should -Not -BeNullOrEmpty -Because "RepoURL is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'RepoURL' column" {
            $duplicates = $csvContent | Group-Object -Property RepoURL | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's RepoURL should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }

        It "Should have a valid URL in the 'RepoURL' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.RepoURL | Should -Match '^(http|https)://.*' -Because "RepoURL should be a valid URL. In line #$lineNumber, this is invalid. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }
    }

    Context 'PublicRegistryReference column' {
        It "Should not have any missing values in the 'PublicRegistryReference' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.PublicRegistryReference | Should -Not -BeNullOrEmpty -Because "PublicRegistryReference is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'PublicRegistryReference' column" {
            $duplicates = $csvContent | Group-Object -Property PublicRegistryReference | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's PublicRegistryReference should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }

        if ($CsvFilePath -match 'Bicep') {
            It "Should have a valid Public Bicep Regisrtry reference in the 'PublicRegistryReference' column" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $item.PublicRegistryReference | Should -Match "^br/public:$($item.ModuleName):X.Y.Z$" -Because "PublicRegistryReference should point to the Public Bicep Registry. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.PublicRegistryReference)"""
                    $lineNumber++
                }
            }
        } elseif ($CsvFilePath -match 'Terraform') {
            It "Should have a valid Terraform registry reference in the 'PublicRegistryReference' column" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $item.PublicRegistryReference | Should -Match "^https://registry.terraform.io/modules/Azure/$($item.ModuleName)/azurerm/latest$" -Because "PublicRegistryReference should be a valid URL. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.PublicRegistryReference)"""
                    $lineNumber++
                }
            }
        }
    }

    Context 'TelemetryIdPrefix column' {
        BeforeAll {

        }

        It "Should not have any missing values in the 'TelemetryIdPrefix' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.TelemetryIdPrefix | Should -Not -BeNullOrEmpty -Because "TelemetryIdPrefix is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'TelemetryIdPrefix' column" {
            $duplicates = $csvContent | Group-Object -Property TelemetryIdPrefix | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's TelemetryIdPrefix should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }

        It 'Telemetry ID prefix should be shorter than 49 characters' {
            foreach ($item in $csvContent) {
                $item.TelemetryIdPrefix.Length | Should -BeLessOrEqual 49 -Verbose -Because "deployments names must be under 64 characters. To keep the entire deployment name under 64 characters, $($item.TelemetryIdPrefix) should be shorter than 49"
            }
        }

        if ($CsvFilePath -match 'Bicep') {
            if ($CsvFilePath -match 'ResourceModules') {
                It 'Telemetry ID prefix should start with "46d3xbcp.res."' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.TelemetryIdPrefix | Should -Match '^46d3xbcp.res.*$' -Because "TelemetryIdPrefix should start with '46d3xbcp.res.'. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.TelemetryIdPrefix)"""
                    }
                    $lineNumber++
                }
            } elseif ($CsvFilePath -match 'PatternModules') {
                It 'Telemetry ID prefix should start with "46d3xbcp.ptn."' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.TelemetryIdPrefix | Should -Match '^46d3xbcp.ptn.*$' -Because "TelemetryIdPrefix should start with '46d3xbcp.ptn.'. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.TelemetryIdPrefix)"""
                    }
                    $lineNumber++
                }
            } elseif ($CsvFilePath -match 'UtilityModules') {
                It 'Telemetry ID prefix should start with "46d3xbcp.ptn."' {
                    $lineNumber = 2
                    foreach ($item in $csvContent) {
                        $item.TelemetryIdPrefix | Should -Match '^46d3xbcp.utl.*$' -Because "TelemetryIdPrefix should start with '46d3xbcp.utl.'. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.TelemetryIdPrefix)"""
                    }
                    $lineNumber++
                }
            }

        }
    }

    Context 'PrimaryModuleOwnerGHHandle column' {
        It "Should have a value for 'Available' modules" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Available :green_circle:') {
                    $item.PrimaryModuleOwnerGHHandle | Should -Not -BeNullOrEmpty -Because "PrimaryModuleOwnerGHHandle is a required field for 'Available' modules. This should have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It "hould be empty for 'Orphaned' modules" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Orphaned :eyes:') {
                    $item.PrimaryModuleOwnerGHHandle | Should -BeNullOrEmpty -Because "PrimaryModuleOwnerGHHandle field must be empty for 'Orphaned' modules. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should have a value if the PrimaryModuleOwnerDisplayName also has a value' {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.PrimaryModuleOwnerDisplayName -ne '') {
                    $item.PrimaryModuleOwnerGHHandle | Should -Not -BeNullOrEmpty -Because "PrimaryModuleOwnerGHHandle should have a value if PrimaryModuleOwnerDisplayName has a value. This should have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should be a valid GitHub handle' {
            $PrimaryModuleOwnerGHHandles = $csvContent.PrimaryModuleOwnerGHHandle | Where-Object { $_ -ne '' } | Select-Object -Unique
            foreach ($item in $PrimaryModuleOwnerGHHandles) {
                $GHUser = (& gh api users/$item) | ConvertFrom-Json
                $GHUser.login | Should -Not -BeNullOrEmpty -Because "PrimaryModuleOwnerGHHandle ($item) should be a valid GitHub handle"

            }
        }
    }

    Context 'PrimaryModuleOwnerDisplayName column' {
        It "Should have a value for 'Available' modules" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Available :green_circle:') {
                    $item.PrimaryModuleOwnerDisplayName | Should -Not -BeNullOrEmpty -Because "PrimaryModuleOwnerDisplayName is a required field for 'Available' modules. This should have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It "Should be empty for 'Orphaned' modules" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Orphaned :eyes:') {
                    $item.PrimaryModuleOwnerDisplayName | Should -BeNullOrEmpty -Because "PrimaryModuleOwnerDisplayName field must be empty for 'Orphaned' modules. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should have a value if the PrimaryModuleOwnerGHHandle also has a value' {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.PrimaryModuleOwnerGHHandle -ne '') {
                    $item.PrimaryModuleOwnerDisplayName | Should -Not -BeNullOrEmpty -Because "PrimaryModuleOwnerDisplayName should have a value if PrimaryModuleOwnerGHHandle has a value. This should have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }
    }

    Context 'SecondaryModuleOwnerGHHandle column' {
        It "Should be empty for 'Orphaned' modules" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Orphaned :eyes:') {
                    $item.SecondaryModuleOwnerGHHandle | Should -BeNullOrEmpty -Because "SecondaryModuleOwnerGHHandle field must be empty for 'Orphaned' modules. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should not have a value if the PrimaryModuleOwnerDisplayName is empty' {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.PrimaryModuleOwnerDisplayName -eq '') {
                    $item.PrimaryModuleOwnerGHHandle | Should -BeNullOrEmpty -Because "PrimaryModuleOwnerGHHandle should be empty if PrimaryModuleOwnerDisplayName is empty. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should be a valid GitHub handle' {
            $SecondaryModuleOwnerGHHandles = $csvContent.SecondaryModuleOwnerGHHandle | Where-Object { $_ -ne '' } | Select-Object -Unique
            foreach ($item in $SecondaryModuleOwnerGHHandles) {
                $GHUser = (& gh api users/$item) | ConvertFrom-Json
                $GHUser.login | Should -Not -BeNullOrEmpty -Because "SecondaryModuleOwnerGHHandle ($item) should be a valid GitHub handle"

            }
        }
    }

    Context 'SecondaryModuleOwnerDisplayName column' {
        It "Should be empty for 'Orphaned' modules" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Orphaned :eyes:') {
                    $item.SecondaryModuleOwnerDisplayName | Should -BeNullOrEmpty -Because "SecondaryModuleOwnerDisplayName field must be empty for 'Orphaned' modules. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It 'Should not have a value if the PrimaryModuleOwnerGHHandle is empty' {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.PrimaryModuleOwnerGHHandle -eq '') {
                    $item.SecondaryModuleOwnerDisplayName | Should -BeNullOrEmpty -Because "SecondaryModuleOwnerDisplayName should be empty if PrimaryModuleOwnerGHHandle is empty. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }
    }

    Context 'ModuleOwnersGHTeam column' {
        It "Should not have any missing values in the 'ModuleOwnersGHTeam' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.ModuleOwnersGHTeam | Should -Not -BeNullOrEmpty -Because "ModuleOwnersGHTeam is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'ModuleOwnersGHTeam' column" {
            $duplicates = $csvContent | Group-Object -Property ModuleOwnersGHTeam | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's ModuleOwnersGHTeam should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }

        if ($CsvFilePath -match 'Bicep') {
            It "Should have a valid GitHub team name in the 'ModuleOwnersGHTeam' column" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $teamName = $item.ModuleName -replace '-', '' -replace '/', '-'
                    $item.ModuleOwnersGHTeam | Should -Match "^@Azure/$teamName-module-owners-bicep$" -Because "ModuleOwnersGHTeam should follow the naming convention. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.ModuleOwnersGHTeam)"""
                    $lineNumber++
                }
            }
        } elseif ($CsvFilePath -match 'Terraform') {
            It "Should have a valid GitHub team name in the 'ModuleOwnersGHTeam' column" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $item.ModuleOwnersGHTeam | Should -Match '^@Azure/avm-.*-module-owners-tf$' -Because "ModuleOwnersGHTeam should follow the naming convention. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.ModuleOwnersGHTeam)"""
                    $lineNumber++
                }
            }
        }
    }

    Context 'ModuleContributorsGHTeam column' {
        It "Should not have any missing values in the 'ModuleContributorsGHTeam' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.ModuleContributorsGHTeam | Should -Not -BeNullOrEmpty -Because "ModuleContributorsGHTeam is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'ModuleContributorsGHTeam' column" {
            $duplicates = $csvContent | Group-Object -Property ModuleContributorsGHTeam | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's ModuleContributorsGHTeam should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }

        if ($CsvFilePath -match 'Bicep') {
            It "Should have a valid GitHub team name in the 'ModuleContributorsGHTeam' column" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $teamName = $item.ModuleName -replace '-', '' -replace '/', '-'
                    $item.ModuleContributorsGHTeam | Should -Match "^@Azure/$teamName-module-contributors-bicep$" -Because "ModuleContributorsGHTeam should follow the naming convention. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.ModuleContributorsGHTeam)"""
                    $lineNumber++
                }
            }
        } elseif ($CsvFilePath -match 'Terraform') {
            It "Should have a valid GitHub team name in the 'ModuleContributorsGHTeam' column" {
                $lineNumber = 2
                foreach ($item in $csvContent) {
                    $item.ModuleContributorsGHTeam | Should -Match '^@Azure/avm-.*-module-contributors-tf$' -Because "ModuleContributorsGHTeam should follow the naming convention. In line #$lineNumber, this is invalid. The following value have been provided: ""$($item.ModuleContributorsGHTeam)"""
                    $lineNumber++
                }
            }
        }
    }

    Context 'Description column' {
        It "Should not have any missing values in the 'Description' column" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                $item.Description | Should -Not -BeNullOrEmpty -Because "Description is a required field. In line #$lineNumber, this is empty. The following values have been provided: ""$($item)"""
                $lineNumber++
            }
        }

        It "Should not have any duplicate values in the 'Description' column" {
            $duplicates = $csvContent | Group-Object -Property Description | Where-Object Count -GT 1
            $duplicates | Should -BeNullOrEmpty -Because "each module's Description should be unique. This is a duplicate: ""$($duplicates.Name)"""
        }
    }

    Context 'FirstPublishedIn column' {
        It "If the module is 'Proposed' then the 'FirstPublishedIn' column should be empty" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Proposed :new:') {
                    $item.FirstPublishedIn | Should -BeNullOrEmpty -Because "FirstPublishedIn should be empty for 'Proposed' modules. This should not have a value in line #$lineNumber"
                }
                $lineNumber++
            }
        }

        It "If the module is 'Available' or 'Orphaned' then the 'FirstPublishedIn' column should be a valid date in YYYY-MM format" {
            $lineNumber = 2
            foreach ($item in $csvContent) {
                if ($item.ModuleStatus -eq 'Available :green_circle:' -or $item.ModuleStatus -eq 'Orphaned :eyes:') {
                    $item.FirstPublishedIn | Should -Match '^20\d{2}-(0[1-9]|1[0-2])$' -Because "FirstPublishedIn should be a valid date for 'Available' modules. This should have a valid value in line #$lineNumber"
                }
                $lineNumber++
            }
        }
    }
}
