Function Get-AvmCsvData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet('Bicep-Resource','Bicep-Pattern', 'Terraform-Resource','Terraform-Pattern')]
        [string]$ModuleIndex
    )

    # Retrieve the CSV file
    if ($ModuleIndex -eq 'Bicep-Resource') {
        try {
            $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/bicep/res/csv"
        }
        catch {
            Write-Error "Unable to retrieve CSV file - Check network connection."
        }
    }
    elseif ($ModuleIndex -eq 'Bicep-Pattern') {
        try {
            $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/bicep/ptn/csv"
        }
        catch {
            Write-Error "Unable to retrieve CSV file - Check network connection."
        }
    }
    elseif ($ModuleIndex -eq 'Terraform-Resource') {
        try {
            $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/tf/res/csv"
        }
        catch {
            Write-Error "Unable to retrieve CSV file - Check network connection."
        }
    }
    elseif ($ModuleIndex -eq 'Terraform-Pattern') {
        try {
            $unfilteredCSV = Invoke-WebRequest -Uri "https://aka.ms/avm/index/tf/ptn/csv"
        }
        catch {
            Write-Error "Unable to retrieve CSV file - Check network connection."
        }
    }
    else {
        Write-Error "Invalid ModuleIndex value"
        exit 1
    }

    # Convert the CSV content to a PowerShell object
    $formattedBicepFullCsv = ConvertFrom-CSV $unfilteredCSV.Content
    # Filter the CSV data where the ModuleStatus is 'Available :green_circle:'
    $filterCsvAvailableBicepModule = $formattedBicepFullCsv | Where-Object {$_.ModuleStatus -eq 'Available :green_circle:'}

    # Loop through each item in the filtered data
    foreach ($item in $filterCsvAvailableBicepModule) {
        # Remove '@Azure/' from the ModuleOwnersGHTeam property
        $item.ModuleOwnersGHTeam = $item.ModuleOwnersGHTeam -replace '@Azure/', ''
        # Remove '@Azure/' from the ModuleContributorsGHTeam property
        $item.ModuleContributorsGHTeam = $item.ModuleContributorsGHTeam -replace '@Azure/', ''
    }

    # Return the filtered and modified data
    return $filterCsvAvailableBicepModule
}
