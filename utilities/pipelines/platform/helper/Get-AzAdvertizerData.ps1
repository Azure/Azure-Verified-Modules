function Get-AzAdvertizerDataPerType {
  param(
    [ValidateSet("AZQR", "Advisor", "APRL", "PSRule")]
    [string]$Type
  )

  switch ($Type) {
    'AZQR' { $Url = 'https://www.azadvertizer.net/js/rts-azqr.js' }
    'Advisor' { $Url = 'https://www.azadvertizer.net/js/rts-advisor.js' }
    'APRL' { $Url = 'https://www.azadvertizer.net/js/rts-aprlv2.js' }
    'PSRule' { $Url = 'https://www.azadvertizer.net/js/rts-psRule.js' }
  }

  $content = Invoke-WebRequest -Uri $Url

  # Remove any JS variable assignment if present
  if ($content -match '^(var|let|const)\s+\w+\s*=\s*') {
    $content = $content -replace '^(var|let|const)\s+\w+\s*=\s*', ''
  }
  # Remove trailing semicolon if present
  $content = $content.TrimEnd(';') | ConvertFrom-Json

  return $content
}

function Get-AllAzAdvertizerData {
  param(
    [string[]]$AdvisorRecommendationCategories = @('HighAvailability', 'Reliability', 'Security'),
    [string[]]$AdvisorRecommendationImpact = @('High'),
    [string[]]$APRLRecommendationImpact = @('High'),
    [string[]]$PSRulePillars = @('Security', 'Reliability'),
    [string[]]$PSRuleSeverities = @('Critical', 'Important')
  )
  $types = @("PSRule", "Advisor", "APRL")
  $results = @{}
  foreach ($type in $types) {
    $data = Get-AzAdvertizerDataPerType -Type $type
    foreach ($resource in $data.PSObject.Properties.Name) {
      $recommendations = $data.$resource
      foreach ($recommendation in $recommendations) {
        $include = $false
        switch ($type) {
          'Advisor' {
            if ($recommendation.recommendationCategory -in $AdvisorRecommendationCategories -and $recommendation.recommendationImpact -in $AdvisorRecommendationImpact) {
              $include = $true
            }
          }
          'APRL' {
            if ($recommendation.recommendationImpact -in $APRLRecommendationImpact) {
              $include = $true
            }
          }
          'PSRule' {
            if (($recommendation.pillar -in $PSRulePillars) -and ($recommendation.severity -in $PSRuleSeverities)) {
              $include = $true
            }
          }
        }
        if ($include) {
          if (-not $results.ContainsKey($resource)) {
            $results[$resource] = @{}
          }
          if (-not $results[$resource].ContainsKey($type)) {
            $results[$resource][$type] = New-Object System.Collections.ArrayList
          }
          $results[$resource][$type].Add($recommendation) | Out-Null
        }
      }
    }
  }
  return $results
}

function Export-AzAdvertizerDataToCsv {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )
  $Data = Get-AllAzAdvertizerData
  $allTypes = @()
  foreach ($resource in $Data.Keys) {
    $allTypes += $Data[$resource].Keys
  }
  $allTypes = $allTypes | Select-Object -Unique

  $csvRows = @()
  foreach ($resource in $Data.Keys) {
    foreach ($type in $allTypes) {
      if ($Data[$resource].ContainsKey($type)) {
        [array]$rules = $Data[$resource][$type]
        foreach ($rule in $rules) {
          $row = @{
            'ResourceType' = $resource
            'Advisor'      = ''
            'APRL'         = ''
            'PSRule'       = ''
          }
          switch ($type) {
            'PSRule' {
              $row[$type] = '=HYPERLINK("https://azure.github.io/PSRule.Rules.Azure/en/rules/{0}";"{1}")' -f $rule."ruleId", $rule."displayName"
            }
            'Advisor' {
              $row[$type] = '=HYPERLINK("https://portal.azure.com/#view/Microsoft_Azure_Expert/RecommendationList.ReactView/recommendationTypeId/{0}";"{1}")' -f $rule."id", $rule."displayName".Replace('"', '""')
            }
            'APRL' {
              $row[$type] = '=HYPERLINK("https://azure.github.io/Azure-Proactive-Resiliency-Library-v2/azure-resources/{0}/#{1}";"{2}")' -f $rule."recommendationSitePath", $rule."description".ToLower().Replace(' ', '-').Replace('"', ''), $rule."description".Replace('"', '""')
            }
          }
          $csvRows += (New-Object PSObject -Property $row)
        }
      }
    }
  }
  $csvRows | Sort-Object -Property 'ResourceType' | Export-Csv -Path $Path -NoTypeInformation -Force
}

function Get-AzAdvertizerDataDiff {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Path
  )
  if (-Not (Test-Path $Path)) {
    throw "File not found: $Path"
  }

  $oldData = Import-Csv -Path $Path

  $oldData | ForEach-Object {
    $_.Advisor = if ($_.Advisor -ne '') { $_.Advisor -replace '^=HYPERLINK\("https://portal\.azure\.com/#view/Microsoft_Azure_Expert/RecommendationList\.ReactView/recommendationTypeId/([^"\)]+)"\s*;\s*"[^"]*"\)$', '$1' } else { '' }
    $_.APRL = if ($_.APRL -ne '') { $_.APRL -replace '^=HYPERLINK\("([^"]+)"\s*;\s*"([^"]+)"\)$', '$2' } else { '' }
    $_.PSRule = if ($_.PSRule -ne '') { $_.PSRule -replace '^=HYPERLINK\("https://azure\.github\.io/PSRule\.Rules\.Azure/en/rules/([^"]+)"\s*;\s*"[^"]*"\)$', '$1' } else { '' }
  }

  $oldDataHash = @{}
  foreach ($row in $oldData) {
    if (-not $oldDataHash.ContainsKey($row.ResourceType)) {
      $oldDataHash[$row.ResourceType] = @{
        AdvisorId       = @()
        APRLDescription = @()
        PSRuleId        = @()
      }
    }
    if ($row.Advisor -ne '') { $oldDataHash[$row.ResourceType].AdvisorId += $row.Advisor }
    if ($row.APRL -ne '') { $oldDataHash[$row.ResourceType].APRLDescription += $row.APRL }
    if ($row.PSRule -ne '') { $oldDataHash[$row.ResourceType].PSRuleId += $row.PSRule }
  }

  $CurrentData = Get-AllAzAdvertizerData

  # check if the data has changed
  $addedData = @{}

  foreach ($resource in $CurrentData.Keys) {
    foreach ($type in $CurrentData[$resource].Keys) {
      foreach ($rule in $CurrentData[$resource][$type]) {
        switch ($type) {
          'Advisor' {
            if ($rule.id -notin $oldDataHash[$resource].AdvisorId) {
              if (-not $addedData.ContainsKey($resource)) {
                $addedData[$resource] = @{
                  AdvisorId = @()
                  APRLGuid  = @()
                  PSRuleId  = @()
                }
              }
              $addedData[$resource].AdvisorId += $rule.id
            }
          }
          'APRL' {
            if ($rule.description -notin $oldDataHash[$resource].APRLDescription) {
              if (-not $addedData.ContainsKey($resource)) {
                $addedData[$resource] = @{
                  AdvisorId = @()
                  APRLGuid  = @()
                  PSRuleId  = @()
                }
              }
              $addedData[$resource].APRLGuid += $rule.aprlGuid
            }
          }
          'PSRule' {
            if ($rule.ruleId -notin $oldDataHash[$resource].PSRuleId) {
              if (-not $addedData.ContainsKey($resource)) {
                $addedData[$resource] = @{
                  AdvisorId = @()
                  APRLGuid  = @()
                  PSRuleId  = @()
                }
              }
              $addedData[$resource].PSRuleId += $rule.ruleId
            }
          }
        }
      }
    }
  }

  return $addedData
}

function Format-AzAdvertizerDataDiff {
  param(
    [Parameter(Mandatory = $true)]
    [hashtable]$DiffData
  )

  if ($DiffData.Count -eq 0) {
    return "No new recommendations found."
  }

  $output = @()
  $output += "=" * 80
  $output += "Azure Advertizer Data Diff Report"
  $output += "=" * 80
  $output += ""

  foreach ($resourceType in ($DiffData.Keys | Sort-Object)) {
    $resource = $DiffData[$resourceType]
    $hasNewItems = ($resource.AdvisorId.Count -gt 0) -or ($resource.APRLGuid.Count -gt 0) -or ($resource.PSRuleId.Count -gt 0)

    if ($hasNewItems) {
      $output += "Resource Type: $resourceType"
      $output += "-" * 50

      if ($resource.AdvisorId.Count -gt 0) {
        $output += "  New Advisor Recommendations:"
        foreach ($advisorId in $resource.AdvisorId) {
          $output += "    - $advisorId"
        }
        $output += ""
      }

      if ($resource.APRLGuid.Count -gt 0) {
        $output += "  New APRL Recommendations:"
        foreach ($aprlGuid in $resource.APRLGuid) {
          $output += "    - $aprlGuid"
        }
        $output += ""
      }

      if ($resource.PSRuleId.Count -gt 0) {
        $output += "  New PSRule Recommendations:"
        foreach ($psRuleId in $resource.PSRuleId) {
          $output += "    - $psRuleId"
        }
        $output += ""
      }

      $output += ""
    }
  }

  if ($output.Count -eq 4) {
    return "No new recommendations found for any resource types."
  }

  return $output -join "`n"
}

function Export-PSRuleDataToCsv {
  $rawPsRules = Get-AzAdvertizerDataPerType -Type 'PSRule'
  $csvRows = @()

  foreach ($resource in $rawPsRules.PSObject.Properties.Name) {
    $rules = $rawPsRules.$resource
    foreach ($rule in $rules) {
      $csvRows += [PSCustomObject]@{
        Severity       = $rule.severity
        Pillar         = $rule.pillar
        ResourceType   = $rule.resourceType
        RuleId        = $rule.ruleId
        DisplayName    = $rule.displayName
      }
    }
  }

  $csvRows | Sort-Object -Property 'RuleId' | Export-Csv -Path "PSRule.csv" -NoTypeInformation -Force
}
