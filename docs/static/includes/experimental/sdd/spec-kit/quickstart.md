# Quickstart: Deploy Legacy Windows Server VM Workload

**Estimated Time**: 20-25 minutes
**Prerequisites**: Azure CLI or Azure PowerShell, Azure subscription with Contributor access

## Pre-Deployment

### 1. Verify Prerequisites

```bash
# Check Azure CLI version (2.50.0 or higher recommended)
az --version

# Login to Azure
az login

# Set subscription
az account set --subscription "<subscription-id>"

# Verify quota in US West 3
az vm list-usage --location westus3 --query "[?name.value=='cores'].{Name:name.localizedValue, CurrentValue:currentValue, Limit:limit}"
```

### 2. Clone Repository and Navigate to Infra

```bash
cd c:\SOURCE\avm-workload\infra
```

### 3. Review and Customize Parameters

Edit `main.bicepparam`:
- Set `workloadName` (default: `'legacyvm'`)
- Choose `availabilityZone` (1, 2, or 3)
- Customize `vmAdminUsername` if needed
- Adjust `vmAdminSecretName` if required

## Deployment

### 4. Validate Template (MANDATORY per Constitution Principle IV)

```bash
# Azure CLI
az deployment group validate \
  --resource-group rg-legacyvm-prod \
  --template-file main.bicep \
  --parameters main.bicepparam

# PowerShell
New-AzResourceGroupDeployment `
  -ResourceGroupName rg-legacyvm-prod `
  -TemplateFile .\main.bicep `
  -TemplateParameterFile .\main.bicepparam `
  -WhatIf
```

**Expected Output**: Zero errors. Review What-If output for expected resource creation.

### 5. Deploy Template

```bash
# Azure CLI (recommended)
az deployment group create \
  --name legacyvm-deployment-$(date +%Y%m%d-%H%M%S) \
  --resource-group rg-legacyvm-prod \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --verbose

# PowerShell
$deploymentName = "legacyvm-deployment-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
New-AzResourceGroupDeployment `
  -Name $deploymentName `
  -ResourceGroupName rg-legacyvm-prod `
  -TemplateFile .\main.bicep `
  -TemplateParameterFile .\main.bicepparam `
  -Verbose
```

**Duration**: 15-20 minutes (Bastion creation is slowest component)

### 6. Capture Deployment Outputs

```bash
# Azure CLI
az deployment group show \
  --resource-group rg-legacyvm-prod \
  --name $deploymentName \
  --query properties.outputs

# PowerShell
$deployment = Get-AzResourceGroupDeployment -ResourceGroupName rg-legacyvm-prod -Name $deploymentName
$deployment.Outputs
```

**Save These Values**:
- `vmName`: VM name for Bastion connection
- `fileShareMountCommand`: PowerShell command for file share mounting
- `keyVaultName`: Key Vault name for password retrieval

## Post-Deployment

### 7. Retrieve VM Admin Password

```bash
# Azure CLI
az keyvault secret show \
  --vault-name $(az deployment group show --resource-group rg-legacyvm-prod --name $deploymentName --query properties.outputs.keyVaultName.value -o tsv) \
  --name vm-admin-password \
  --query value -o tsv

# PowerShell
$kvName = $deployment.Outputs.keyVaultName.Value
Get-AzKeyVaultSecret -VaultName $kvName -Name vm-admin-password -AsPlainText
```

**Security**: Store password securely (password manager). Do not commit to source control.

### 8. Connect to VM via Bastion

1. Navigate to Azure Portal → Virtual Machines → vm-legacyvm
2. Click "Connect" → "Bastion"
3. Enter:
   - **Username**: `vmadmin` (or custom value from parameters)
   - **Password**: Retrieved from Key Vault in step 7
4. Click "Connect"

**Expected**: RDP session opens in browser tab

### 9. Mount File Share (Manual)

In the VM RDP session, open PowerShell:

```powershell
# Use the command from deployment outputs
net use Z: \\stlegacyvmxxxxxx.file.core.windows.net\fs-legacyvm /persistent:yes

# Verify mount
dir Z:
```

**Alternative Method** (if storage key needed):
```bash
# Get storage account key
az storage account keys list \
  --resource-group rg-legacyvm-prod \
  --account-name $(az deployment group show --resource-group rg-legacyvm-prod --name $deploymentName --query properties.outputs.storageAccountName.value -o tsv) \
  --query [0].value -o tsv
```

### 10. Verify Diagnostic Logging

```bash
# Check Log Analytics workspace has data
az monitor log-analytics query \
  --workspace $(az deployment group show --resource-group rg-legacyvm-prod --name $deploymentName --query properties.outputs.logAnalyticsWorkspaceId.value -o tsv) \
  --analytics-query "AzureDiagnostics | where TimeGenerated > ago(1h) | summarize count() by Resource" \
  --output table
```

**Expected**: Rows showing VM, Storage Account, Key Vault, Bastion logs

### 11. Verify Alerts Configured

Navigate to Azure Portal → Monitor → Alerts → Alert Rules. Verify:
- ✅ `alert-vm-stopped-legacyvm-*` exists
- ✅ `alert-disk-capacity-legacyvm-*` exists
- ✅ `alert-kv-access-legacyvm-*` exists

## Troubleshooting

### Deployment Failures

**Partial failure** (e.g., VM created but Bastion failed):
1. DO NOT delete resources (Constitution Principle II)
2. Review error message in deployment logs
3. Fix error in template or parameters
4. Redeploy entire template (ARM incremental mode will skip existing resources)

```bash
# Retry deployment
az deployment group create \
  --name legacyvm-deployment-retry-$(date +%Y%m%d-%H%M%S) \
  --resource-group rg-legacyvm-prod \
  --template-file main.bicep \
  --parameters main.bicepparam \
  --verbose
```

### Common Errors

**Error**: "Quota exceeded for VM cores"
- **Solution**: Request quota increase in US West 3 or choose smaller VM size

**Error**: "Storage account name already exists"
- **Solution**: Random suffix collision (very rare); redeploy to generate new suffix

**Error**: "Key Vault name already exists"
- **Solution**: Previous Key Vault in soft-delete state; purge or wait 90 days

### Bastion Connection Issues

- Verify VM is running: Azure Portal → VM → Overview → Status = "Running"
- Verify Bastion deployed: Azure Portal → Bastion Hosts
- Check NSG rules: VM subnet NSG allows RDP from AzureBastionSubnet

### File Share Mount Issues

- Verify private endpoint exists: Azure Portal → Storage Account → Networking → Private Endpoints
- Check DNS resolution from VM: `nslookup stlegacyvmxxxxxx.file.core.windows.net` (should resolve to private IP)
- Verify VM is in correct subnet (same VNet as private endpoint)

## Compliance Checklist

After deployment, verify:
- ✅ All resources in `rg-legacyvm-*` resource group
- ✅ All resources in `westus3` region
- ✅ CanNotDelete locks applied (Portal → Resource Group → Locks)
- ✅ Diagnostic settings enabled (Portal → each resource → Diagnostic settings)
- ✅ No public IPs exposed (VM has private IP only)
- ✅ Storage account public access disabled (Portal → Storage → Networking)
- ✅ Key Vault audit logging enabled (Portal → Key Vault → Diagnostic settings)
- ✅ VM admin password stored in Key Vault
- ✅ Alerts configured for critical events

## Rollback

To rollback to previous deployment:
1. Locate previous Bicep template version (from source control)
2. Deploy previous version using same process above
3. ARM incremental mode will update changed resources only

**DO NOT** use ARM complete mode (risks deleting unmanaged resources).

## Next Steps

- Install legacy business application on VM
- Configure application to use Z: drive (file share) for data storage
- Test application functionality
- Document application-specific configuration in runbook
- Schedule quarterly compliance review per Constitution governance
