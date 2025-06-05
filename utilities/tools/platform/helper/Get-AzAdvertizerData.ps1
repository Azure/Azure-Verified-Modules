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
        [array]$rules = $Data[$resource][$type] #| ConvertTo-Json -Compress
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

function Import-AzAdvertizerDataFromCsv {
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
                AdvisorId = @()
                APRLDescription = @()
                PSRuleId = @()
            }
        }
        if ($row.Advisor -ne '') { $oldDataHash[$row.ResourceType].AdvisorId += $row.Advisor }
        if ($row.APRL -ne '') { $oldDataHash[$row.ResourceType].APRLDescription += $row.APRL }
        if ($row.PSRule -ne '') { $oldDataHash[$row.ResourceType].PSRuleId += $row.PSRule }
    }

    $CurrentData = Get-AllAzAdvertizerData

    return $oldDataHash
}
