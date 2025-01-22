---
title: SNFR23 - GitHub Repo Labels
url: /spec/SNFR23
type: default
tags: [
  Class-Resource, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Class-Pattern, # MULTIPLE VALUES: this can be "Class-Resource" AND/OR "Class-Pattern" AND/OR "Class-Utility"
  Type-NonFunctional, # SINGLE VALUE: this can be "Type-Functional" OR "Type-NonFunctional"
  Category-Contribution/Support, # SINGLE VALUE: this can be "Category-Testing" OR "Category-Telemetry" OR "Category-Contribution/Support" OR "Category-Documentation" OR "Category-CodeStyle" OR "Category-Naming/Composition" OR "Category-Inputs/Outputs" OR "Category-Release/Publishing"
  Language-Bicep, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Language-Terraform, # MULTIPLE VALUES: this can be "Language-Bicep" AND/OR "Language-Terraform"
  Severity-MUST, # SINGLE VALUE: this can be "Severity-MUST" OR "Severity-SHOULD" OR "Severity-MAY"
  Persona-Owner, # MULTIPLE VALUES: this can be "Persona-Owner" AND/OR "Persona-Contributor"
  Lifecycle-BAU, # SINGLE VALUE: this can be "Lifecycle-Initial" OR "Lifecycle-BAU" OR "Lifecycle-EOL"
  Validation-TBD # SINGLE VALUE (PER LANGUAGE): for Bicep, this can be "Validation-BCP/Manual" OR "Validation-BCP/CI/Informational" OR "Validation-BCP/CI/Enforced" and for Terraform, this can be "Validation-TF/Manual" OR "Validation-TF/CI/Informational" OR "Validation-TF/CI/Enforced"
]
priority: 1160
---

#### ID: SNFR23 - Category: Contribution/Support - GitHub Repo Labels

GitHub repositories where modules are held **MUST** use the below labels and **SHOULD** not use any additional labels:

{{% expand title="➕ AVM Standard GitHub Labels" expanded="false" %}}

These labels are available in a CSV file from [here]({{% siteparam base %}}/governance/avm-standard-github-labels.csv)

{{< ghLabelsCsvToTable header=true csv="/static/governance/avm-standard-github-labels.csv" >}}

{{% /expand %}}

To help apply these to a module GitHub repository you can use the below PowerShell script:

{{% expand title="➕ Set-AvmGitHubLabels.ps1" expanded="false" %}}

For most scenario this is the command you'll need to call the below PowerShell script with, replacing the value for `RepositoryName`:

{{< highlight lineNos="false" type="PowerShell" wrap="true" title="Invoke Set-AvmGitHubLabels.ps1" >}}
  Set-AvmGitHubLabels.ps1 -RepositoryName "Org/MyGitHubRepo" -CreateCsvLabelExports $false -NoUserPrompts $true
{{< /highlight >}}

{{< highlight lineNos="false" type="shell" wrap="true" title="docker" >}}

# Linux / MacOs
# For Windows replace $PWD with your the local path or your repository
#
docker run -it -v $PWD:/repo -w /repo mcr.microsoft.com/powershell pwsh -Command '
    #Invoke-WebRequest -Uri "https://azure.github.io/Azure-Verified-Modules/scripts/Set-AvmGitHubLabels.ps1" -OutFile "Set-AvmGitHubLabels.ps1"
    $gh_version = "2.44.1"
    Invoke-WebRequest -Uri "https://github.com/cli/cli/releases/download/v2.44.1/gh_2.44.1_linux_amd64.tar.gz" -OutFile "gh_$($gh_version)_linux_amd64.tar.gz"
    apt-get update && apt-get install -y git
    tar -xzf "gh_$($gh_version)_linux_amd64.tar.gz"
    ls -lsa
    mv "gh_$($gh_version)_linux_amd64/bin/gh" /usr/local/bin/
    rm "gh_$($gh_version)_linux_amd64.tar.gz" && rm -rf "gh_$($gh_version)_linux_amd64"
    gh --version
    ls -lsa
    gh auth login
    $OrgProject = "Azure/terraform-azurerm-avm-res-kusto-cluster"
    gh auth status
    ./Set-AvmGitHubLabels.ps1 -RepositoryName $OrgProject -CreateCsvLabelExports $false -NoUserPrompts $true

  '
{{< /highlight >}}

By default this script will only update and append labels on the repository specified. However, this can be changed by setting the parameter `-UpdateAndAddLabelsOnly` to `$false`, which will remove all the labels from the repository first and then apply the AVM labels from the CSV only.

Make sure you elevate your privilege to admin level or the labels will not be applied to your repository. Go to repos.opensource.microsoft.com/orgs/Azure/repos/<your avm repo> to request admin access before running the script.

Full Script:

These `Set-AvmGitHubLabels.ps1` can be downloaded from <a href="/Azure-Verified-Modules/scripts/Set-AvmGitHubLabels.ps1" download>here</a>.

{{< highlight lineNos="false" type="PowerShell" wrap="true" title="Set-AvmGitHubLabels.ps1" >}}
  {{% include file="/static/scripts/Set-AvmGitHubLabels.ps1"%}}
{{< /highlight >}}

{{% /expand %}}
