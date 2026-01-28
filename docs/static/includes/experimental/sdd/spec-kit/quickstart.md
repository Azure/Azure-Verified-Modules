<!-- markdownlint-disable -->
# Quickstart: Deploy Legacy VM Workload

**Date**: 2026-01-27
**Feature**: [spec.md](../spec.md)
**Purpose**: Step-by-step deployment guide with validation and troubleshooting

## Prerequisites

### Required Tools

1. **Azure CLI** (v2.65.0 or later)
   ```powershell
   # Check version
   az --version

   # Install/upgrade if needed
   # Windows: Download from https://aka.ms/installazurecliwindows
   # Or use winget
   winget install -e --id Microsoft.AzureCLI
   ```

2. **Bicep CLI** (v0.33.0 or later)
   ```powershell
   # Check version
   az bicep version

   # Install/upgrade
   az bicep install
   az bicep upgrade
   ```

3. **PowerShell** (v7.4 or later recommended)
   ```powershell
   # Check version
   $PSVersionTable.PSVersion

   # Install if needed
   winget install --id Microsoft.Powershell --source winget
   ```

### Azure Permissions

You need the following permissions on the target subscription:

- **Owner** or **Contributor** role at subscription or resource group level
- **User Access Administrator** role (if deploying RBAC assignments)
- Permissions to create resources in **westus3** region

### Authentication

```powershell
# Login to Azure
az login

# Set the target subscription
az account set --subscription "<subscription-id-or-name>"

# Verify current context
az account show --output table
```

## Repository Structure

```
avm-workload/
├── infra/
│   ├── main.bicep            # Main infrastructure template
│   ├── main.bicepparam       # Deployment parameters
│   └── bicepconfig.json      # Bicep configuration
├── specs/
│   └── 001-legacy-vm-workload/
│       ├── spec.md           # Feature specification
│       ├── plan.md           # Implementation plan
│       ├── data-model.md     # Architecture documentation
│       └── quickstart.md     # This file
└── .specify/
    └── memory/
        └── constitution.md   # Governance framework
```

## Deployment Workflow

### Step 1: Review Parameters

Edit `infra/main.bicepparam` to customize deployment:

```bicep
using './main.bicep'

// Required parameters
param vmSize = 'Standard_D2s_v3'
param vmAdminUsername = 'vmadmin'
param availabilityZone = 1
param fileShareQuotaGiB = 1024
param logAnalyticsRetentionDays = 30

// Optional: Override resource names
// param vmName = 'vm-custom-name'
// param vnetName = 'vnet-custom-name'
```

**Key Parameters**:
- `vmSize`: Virtual machine SKU (must support Windows Server 2016)
- `vmAdminUsername`: Administrator username for the VM
- `availabilityZone`: Availability zone (1, 2, or 3)
- `fileShareQuotaGiB`: Storage file share quota (default 1024 GiB)
- `logAnalyticsRetentionDays`: Log retention period (30-730 days)

### Step 2: Pre-Deployment Validation

#### 2.1 Bicep Compilation

Verify the template compiles without errors:

```powershell
# Navigate to infrastructure directory
cd C:\SOURCE\avm-workload\infra

# Build Bicep template
bicep build main.bicep

# Check for warnings
# Fix any warnings reported by the analyzer
```

**Expected Output**: `main.json` file created with no errors or warnings.

#### 2.2 Template Validation

Validate deployment against Azure:

```powershell
# Create resource group (if it doesn't exist)
az group create `
  --name rg-legacyvm-prod `
  --location westus3

# Validate deployment
az deployment group validate `
  --resource-group rg-legacyvm-prod `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --verbose

# Check validation result
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Validation passed" -ForegroundColor Green
} else {
    Write-Host "❌ Validation failed - review errors above" -ForegroundColor Red
    exit 1
}
```

**Expected Output**: `provisioningState: Succeeded`

#### 2.3 What-If Analysis

Preview what resources will be created:

```powershell
# Run what-if analysis
az deployment group what-if `
  --resource-group rg-legacyvm-prod `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --verbose

# Review output:
# - Green (+): Resources to be created
# - Yellow (~): Resources to be modified
# - Red (x): Resources to be deleted
# - White (=): No change
```

**Review Checklist**:
- [ ] 1 Virtual Network with 3 subnets
- [ ] 3 Network Security Groups
- [ ] 1 NAT Gateway with Public IP
- [ ] 1 Azure Bastion with Public IP
- [ ] 1 Key Vault with 1 secret
- [ ] 1 Storage Account with 1 file share
- [ ] 1 Private Endpoint
- [ ] 1 Private DNS Zone with VNet link
- [ ] 1 Virtual Machine with NIC, OS disk, data disk
- [ ] 1 Log Analytics Workspace
- [ ] 3 Metric Alerts
- [ ] Multiple diagnostic settings
- [ ] RBAC role assignments

**STOP**: Do not proceed if what-if shows unexpected resource deletions or modifications.

### Step 3: Deploy Infrastructure

#### 3.1 Execute Deployment

```powershell
# Deploy infrastructure
az deployment group create `
  --name "legacyvm-$(Get-Date -Format 'yyyyMMdd-HHmmss')" `
  --resource-group rg-legacyvm-prod `
  --template-file main.bicep `
  --parameters main.bicepparam `
  --verbose

# Deployment typically takes 15-20 minutes
# Monitor progress in Azure Portal: Resource Groups > rg-legacyvm-prod > Deployments
```

**Expected Duration**: 15-20 minutes

**Deployment Phases**:
1. **0-2 min**: Log Analytics, VNet, NSGs
2. **2-8 min**: NAT Gateway, Bastion, Private DNS Zone, Key Vault
3. **8-12 min**: Storage Account, Private Endpoint
4. **12-18 min**: Virtual Machine (longest phase)
5. **18-20 min**: Monitor Alerts

#### 3.2 Monitor Deployment

**Option A: Azure CLI**
```powershell
# Watch deployment status
az deployment group show `
  --name "legacyvm-<timestamp>" `
  --resource-group rg-legacyvm-prod `
  --query "{State:properties.provisioningState, Duration:properties.duration}" `
  --output table
```

**Option B: Azure Portal**
1. Navigate to: [Azure Portal](https://portal.azure.com)
2. Go to: **Resource Groups** > **rg-legacyvm-prod** > **Deployments**
3. Click on the active deployment to see detailed progress
4. Monitor each resource deployment status

### Step 4: Post-Deployment Verification

#### 4.1 Verify Resources

```powershell
# List all resources in the resource group
az resource list `
  --resource-group rg-legacyvm-prod `
  --output table

# Expected count: 20-25 resources
# Key resources to verify:
# - Virtual Machine
# - Virtual Network
# - Storage Account
# - Key Vault
# - Azure Bastion
# - Log Analytics Workspace
```

#### 4.2 Test Bastion Connectivity

**Via Azure Portal**:
1. Go to: **Virtual Machines** > **vm-legacyvm-{random}**
2. Click: **Connect** > **Bastion**
3. Enter credentials:
   - **Username**: `vmadmin`
   - **Password**: Get from Key Vault (see below)
4. Click: **Connect**

**Retrieve VM Password**:
```powershell
# Get Key Vault name
$kvName = az keyvault list `
  --resource-group rg-legacyvm-prod `
  --query "[0].name" `
  --output tsv

# Get VM admin password from Key Vault
az keyvault secret show `
  --name vm-admin-password `
  --vault-name $kvName `
  --query "value" `
  --output tsv
```

**Expected Result**: Successful RDP connection to Windows Server 2016 VM.

#### 4.3 Verify Logs in Log Analytics

```powershell
# Get Log Analytics workspace ID
$workspaceId = az monitor log-analytics workspace show `
  --resource-group rg-legacyvm-prod `
  --workspace-name law-legacyvm-{random} `
  --query "customerId" `
  --output tsv

Write-Host "Log Analytics Workspace ID: $workspaceId"
Write-Host "Portal: https://portal.azure.com#blade/Microsoft_Azure_Monitoring_Logs/LogsBlade/resourceId/%2Fsubscriptions%2F{subscription-id}%2FresourceGroups%2Frg-legacyvm-prod%2Fproviders%2FMicrosoft.OperationalInsights%2Fworkspaces%2Flaw-legacyvm-{random}"
```

**Via Azure Portal**:
1. Go to: **Log Analytics Workspaces** > **law-legacyvm-{random}**
2. Click: **Logs**
3. Run query to verify diagnostic logs:

```kusto
// Query 1: Verify VM activity logs
AzureActivity
| where ResourceGroup == "rg-legacyvm-prod"
| where ResourceType == "Microsoft.Compute/virtualMachines"
| summarize count() by OperationName
| order by count_ desc

// Query 2: Verify Key Vault audit logs
AzureDiagnostics
| where ResourceType == "VAULTS"
| where ResourceGroup == "rg-legacyvm-prod"
| summarize count() by OperationName, ResultType
| order by count_ desc

// Query 3: Verify Storage Account logs
StorageFileLogs
| where AccountName startswith "st"
| summarize count() by OperationName
| order by count_ desc

// Query 4: Check for any errors
AzureDiagnostics
| where ResourceGroup == "rg-legacyvm-prod"
| where Level == "Error"
| project TimeGenerated, ResourceType, OperationName, ResultDescription
| order by TimeGenerated desc
```

**Expected Results**: Logs appearing for all resources within 5-10 minutes of deployment.

#### 4.4 Test Alerts

**Test 1: Disk Space Alert** (Optional - requires VM modification)
```powershell
# WARNING: This will consume disk space on the VM
# Only run if you want to test alert firing

# Connect to VM via Bastion, then run in VM:
# fsutil file createnew C:\testfile.tmp 100000000000  # 100GB file

# Wait 5-10 minutes for alert to fire
# Check: Azure Portal > Monitor > Alerts
```

**Test 2: Key Vault Access Failure** (Safe test)
```powershell
# Attempt to get a non-existent secret (should generate access failure log)
az keyvault secret show `
  --name "non-existent-secret" `
  --vault-name $kvName 2>$null

# Wait 5 minutes, then check:
# Azure Portal > Monitor > Alerts > alert-kv-access-fail-legacyvm-{random}
```

**Expected Behavior**: Alerts visible in Azure Portal within 5-10 minutes of trigger condition.

#### 4.5 Verify Network Connectivity

**From VM (via Bastion RDP session)**:

```powershell
# Test internet connectivity via NAT Gateway
Test-NetConnection -ComputerName google.com -Port 443

# Test Azure DNS resolution
nslookup st{random}.file.core.windows.net

# Verify private endpoint resolution
nslookup st{random}.privatelink.file.core.windows.net

# Expected: Private IP from 10.0.0.128/27 range

# Test file share access (future - after mapping)
# net use Z: \\st{random}.file.core.windows.net\fileshare
```

**Expected Results**:
- Internet access works (NAT Gateway)
- Private endpoint resolves to internal IP (10.0.0.128/27)
- File share accessible from VM

## Troubleshooting

### Issue: Bicep Build Fails

**Symptoms**: `bicep build` reports errors or warnings

**Solutions**:
1. **Check Bicep CLI version**:
   ```powershell
   az bicep version
   # Should be v0.33.0 or later
   az bicep upgrade
   ```

2. **Review analyzer warnings**:
   - Open `main.bicep` in VS Code with Bicep extension
   - Fix any red/yellow squiggles
   - Common issues: outdated module versions, missing required parameters

3. **Validate bicepconfig.json**:
   ```powershell
   # Ensure file exists and is valid JSON
   Get-Content infra/bicepconfig.json | ConvertFrom-Json
   ```

### Issue: Validation Fails

**Symptoms**: `az deployment group validate` returns errors

**Common Errors**:

1. **"Resource provider not registered"**
   ```powershell
   # Register required providers
   az provider register --namespace Microsoft.Compute
   az provider register --namespace Microsoft.Network
   az provider register --namespace Microsoft.Storage
   az provider register --namespace Microsoft.KeyVault
   az provider register --namespace Microsoft.Insights

   # Wait for registration to complete (2-5 minutes)
   az provider show --namespace Microsoft.Compute --query "registrationState"
   ```

2. **"Quota exceeded"**
   - Check Azure subscription quotas
   - Request quota increase if needed: Portal > Subscriptions > Usage + quotas

3. **"Invalid parameter value"**
   - Review `main.bicepparam` for typos
   - Ensure `vmSize` is valid for westus3 region
   - Verify availability zone is 1, 2, or 3

### Issue: Deployment Hangs or Times Out

**Symptoms**: Deployment runs longer than 30 minutes

**Diagnosis**:
```powershell
# Check deployment status
az deployment group show `
  --name "legacyvm-<timestamp>" `
  --resource-group rg-legacyvm-prod `
  --query "properties.{State:provisioningState, SubState:provisioningDetails}" `
  --output json

# View deployment operations
az deployment operation group list `
  --resource-group rg-legacyvm-prod `
  --name "legacyvm-<timestamp>" `
  --query "[?properties.provisioningState=='Failed' || properties.provisioningState=='Running']" `
  --output table
```

**Solutions**:
1. **VM creation timeout**: May indicate VM extension failures
   - Check: Portal > VM > Extensions and applications
   - Solution: Redeploy with `--no-wait` flag, monitor separately

2. **Bastion timeout**: Check Public IP allocation
   - Verify Public IP quota not exceeded
   - Check NSG rules on Bastion subnet

3. **Private Endpoint timeout**: DNS propagation delay
   - Wait additional 5-10 minutes
   - Verify Private DNS Zone linked to VNet

### Issue: VM Password Not Working

**Symptoms**: Cannot connect to VM via Bastion with retrieved password

**Solutions**:
1. **Re-retrieve password from Key Vault**:
   ```powershell
   $kvName = az keyvault list --resource-group rg-legacyvm-prod --query "[0].name" -o tsv
   $password = az keyvault secret show --name vm-admin-password --vault-name $kvName --query "value" -o tsv
   Write-Host "Password: $password"
   ```

2. **Check Key Vault access**:
   ```powershell
   # Ensure you have Key Vault Secrets User role
   az role assignment list `
     --scope /subscriptions/{subscription-id}/resourceGroups/rg-legacyvm-prod/providers/Microsoft.KeyVault/vaults/$kvName `
     --query "[?principalName=='<your-user-email>']" `
     --output table
   ```

3. **Reset VM password** (if secret retrieval works but password is wrong):
   ```powershell
   # This should not be necessary if deployment succeeded
   # Only use as last resort
   az vm user update `
     --resource-group rg-legacyvm-prod `
     --name vm-legacyvm-{random} `
     --username vmadmin `
     --password "NewP@ssw0rd!123"
   ```

### Issue: Bastion Connection Fails

**Symptoms**: Cannot establish Bastion RDP session

**Diagnosis**:
```powershell
# Check Bastion health
az network bastion show `
  --resource-group rg-legacyvm-prod `
  --name bas-legacyvm-{random} `
  --query "{ProvisioningState:provisioningState, DNSName:dnsName}" `
  --output table

# Check VM status
az vm get-instance-view `
  --resource-group rg-legacyvm-prod `
  --name vm-legacyvm-{random} `
  --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" `
  --output tsv
```

**Solutions**:
1. **VM is stopped**: Start the VM
   ```powershell
   az vm start --resource-group rg-legacyvm-prod --name vm-legacyvm-{random}
   ```

2. **Bastion NSG rules incorrect**: Verify Bastion subnet NSG
   - Required: Allow inbound 443 from Internet
   - Required: Allow outbound 3389/22 to VirtualNetwork
   - Check: Portal > NSG > nsg-bastion-legacyvm-{random} > Security rules

3. **Browser issues**: Try different browser or incognito mode

### Issue: No Logs in Log Analytics

**Symptoms**: Queries return no results 10+ minutes after deployment

**Diagnosis**:
```kusto
// Check if workspace is receiving any data
Heartbeat
| where TimeGenerated > ago(1h)
| summarize count()

// Check diagnostic settings configuration
AzureDiagnostics
| where TimeGenerated > ago(1h)
| summarize count() by ResourceType
```

**Solutions**:
1. **Wait longer**: Initial log ingestion can take 10-15 minutes
2. **Verify diagnostic settings**:
   ```powershell
   # Check VM diagnostic settings
   az monitor diagnostic-settings list `
     --resource /subscriptions/{subscription-id}/resourceGroups/rg-legacyvm-prod/providers/Microsoft.Compute/virtualMachines/vm-legacyvm-{random} `
     --query "value[].{Name:name, LogAnalytics:workspaceId}" `
     --output table
   ```

3. **Manual diagnostic setting creation** (if missing):
   - Portal > VM > Diagnostic settings > Add diagnostic setting
   - Select all log categories and metrics
   - Send to Log Analytics workspace: law-legacyvm-{random}

### Issue: Alerts Not Firing

**Symptoms**: Test conditions met but no alerts visible in Portal

**Diagnosis**:
```powershell
# Check alert rules
az monitor metrics alert list `
  --resource-group rg-legacyvm-prod `
  --query "[].{Name:name, Enabled:enabled, Severity:severity}" `
  --output table

# Check alert condition evaluation
az monitor metrics alert show `
  --resource-group rg-legacyvm-prod `
  --name alert-disk-space-legacyvm-{random} `
  --query "{Enabled:enabled, Condition:criteria, State:properties.state}" `
  --output json
```

**Solutions**:
1. **Wait for evaluation window**: Alerts evaluate every 1-5 minutes
2. **Verify alert is enabled**: Should show `"enabled": true`
3. **Check metric availability**:
   ```powershell
   # List available metrics for VM
   az monitor metrics list-definitions `
     --resource /subscriptions/{subscription-id}/resourceGroups/rg-legacyvm-prod/providers/Microsoft.Compute/virtualMachines/vm-legacyvm-{random} `
     --query "[].{Name:name.value, Unit:unit}" `
     --output table
   ```

4. **Review activity log for alert evaluation**:
   - Portal > Monitor > Activity Log
   - Filter: Resource Type = "microsoft.insights/metricalerts"
   - Look for "Evaluate Action" events

## Clean Up Resources

**WARNING**: This will delete ALL resources and data. Ensure you have backups before proceeding.

```powershell
# Delete resource group and all resources
az group delete `
  --name rg-legacyvm-prod `
  --yes `
  --no-wait

# Verify deletion status (takes 5-10 minutes)
az group exists --name rg-legacyvm-prod
# Expected output: false
```

**Cost Estimate**: Keeping resources deployed costs approximately:
- VM (Standard_D2s_v3): ~$70/month
- Storage (1TB file share + disks): ~$50/month
- Bastion: ~$140/month
- Other services (negligible): ~$10/month
- **Total**: ~$270/month in westus3 region

## Next Steps

After successful deployment:

1. **Configure VM**:
   - Install required applications on Windows Server 2016
   - Map file share as network drive: `\\st{random}.file.core.windows.net\fileshare`
   - Configure Windows Firewall rules as needed

2. **Set Up Monitoring**:
   - Configure Log Analytics queries and save as functions
   - Create custom workbooks in Azure Monitor
   - Set up action groups for email/SMS notifications (currently Portal-only)

3. **Implement Backup** (not in scope of this deployment):
   - Azure Backup for VM
   - Azure Files snapshot/backup for file share

4. **Security Hardening** (additional measures):
   - Enable Azure Security Center recommendations
   - Implement Just-In-Time VM access
   - Review and tighten NSG rules based on actual traffic

5. **Operational Procedures**:
   - Document VM maintenance schedules
   - Create runbooks for common tasks
   - Establish change management process

## Support

For issues related to:
- **Bicep**: Review [research.md](./research.md) for module documentation
- **Azure resources**: Check [data-model.md](./data-model.md) for architecture
- **Requirements**: See [spec.md](./spec.md) for detailed specifications
- **Governance**: Review [constitution.md](../../.specify/memory/constitution.md) for principles

For Azure support, visit: https://azure.microsoft.com/support/
