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
  $types = @("PSRule", "AZQR", "Advisor", "APRL")
  $results = @{}
  foreach ($type in $types) {
    $data = Get-AzAdvertizerDataPerType -Type $type
    foreach ($resource in $data.PSObject.Properties.Name) {
      $recommendations = $data.$resource
      foreach ($recommendation in $recommendations) {
        $include = $false
        switch ($type) {
          'Advisor' {
            if ($recommendation.recommendationCategory -in @('HighAvailability', 'Reliability', 'Security') -and $recommendation.recommendationImpact -eq 'High') {
              $include = $true
            }
          }
          'APRL' {
            if ($recommendation.recommendationImpact -eq 'High') {
              $include = $true
            }
          }
          'PSRule' {
            if (($recommendation.pillar -in @('Security', 'Reliability')) -and ($recommendation.severity -in @('Critical', 'Important'))) {
              $include = $true
            }
          }
          default {
            $include = $true
          }
        }
        if ($include) {
          if (-not $results.ContainsKey($resource)) {
            $results[$resource] = @{}
          }
          if (-not $results[$resource].ContainsKey($type)) {
            $results[$resource][$type] = New-Object System.Collections.ArrayList
          }

          $results[$resource][$type].Add($recommendation)
        }
      }
    }
  }
  return $results
}

