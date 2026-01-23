# Bicep Outputs Contract

**File**: `infra/main.bicep` outputs section
**Purpose**: Values exposed after successful deployment

## Outputs

### `resourceGroupName`
- **Type**: `string`
- **Description**: Name of the deployed resource group
- **Example**: `'rg-legacyvm-a7k3m2'`
- **Use Case**: Reference for subsequent operations

### `virtualNetworkId`
- **Type**: `string`
- **Description**: Resource ID of the Virtual Network
- **Use Case**: Network peering or additional subnet creation

### `vmName`
- **Type**: `string`
- **Description**: Name of the virtual machine
- **Example**: `'vm-legacyvm'`
- **Use Case**: VM management operations

### `vmPrivateIP`
- **Type**: `string`
- **Description**: Private IP address of the VM
- **Use Case**: Documentation, network troubleshooting

### `bastionName`
- **Type**: `string`
- **Description**: Name of the Bastion host
- **Use Case**: Bastion connection reference

### `storageAccountName`
- **Type**: `string`
- **Description**: Name of the storage account
- **Example**: `'stlegacyvma7k3m2'`
- **Use Case**: File share mounting

### `fileShareName`
- **Type**: `string`
- **Description**: Name of the Azure Files share
- **Example**: `'fs-legacyvm'`
- **Use Case**: File share mounting path

### `fileShareMountCommand`
- **Type**: `string`
- **Description**: PowerShell command to mount file share on VM
- **Example**: `'net use Z: \\stlegacyvma7k3m2.file.core.windows.net\fs-legacyvm /persistent:yes'`
- **Use Case**: Administrator documentation

### `keyVaultName`
- **Type**: `string`
- **Description**: Name of the Key Vault
- **Example**: `'kv-legacyvm-a7k3m2'`
- **Use Case**: Secret retrieval

### `keyVaultSecretUri`
- **Type**: `string`
- **Description**: URI of the VM admin password secret
- **Use Case**: Credential retrieval (requires RBAC permissions)

### `logAnalyticsWorkspaceId`
- **Type**: `string`
- **Description**: Resource ID of Log Analytics Workspace
- **Use Case**: Additional diagnostic configuration

## Example Output Usage

```bash
# Deploy template
az deployment group create \
  --resource-group my-rg \
  --template-file main.bicep \
  --parameters main.bicepparam

# Retrieve outputs
STORAGE_NAME=$(az deployment group show --resource-group my-rg --name main --query properties.outputs.storageAccountName.value -o tsv)
MOUNT_CMD=$(az deployment group show --resource-group my-rg --name main --query properties.outputs.fileShareMountCommand.value -o tsv)

echo "Storage Account: $STORAGE_NAME"
echo "Mount Command: $MOUNT_CMD"
```
