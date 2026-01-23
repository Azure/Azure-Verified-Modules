# Bicep Parameters Contract

**File**: `infra/main.bicepparam`
**Purpose**: Input parameters for main.bicep deployment

## Required Parameters

### `workloadName`
- **Type**: `string`
- **Description**: Short name for the workload (used in resource naming)
- **Example**: `'legacyvm'`
- **Constraints**: Lowercase alphanumeric only, 3-10 characters
- **Used In**: Resource name generation across all resources

### `location`
- **Type**: `string`
- **Description**: Azure region for resource deployment
- **Default**: `'westus3'`
- **Constraints**: Must be valid Azure region
- **Constitution**: Fixed to `westus3` per Principle V

### `availabilityZone`
- **Type**: `int`
- **Description**: Availability zone for VM deployment
- **Allowed Values**: `[1, 2, 3]`
- **Default**: `1`
- **Constitution**: Must be 1-3, never -1 (FR-015)

### `vmAdminUsername`
- **Type**: `string`
- **Description**: Administrator username for the VM
- **Default**: `'vmadmin'`
- **Constraints**: 1-20 characters, no special characters

### `vmAdminSecretName`
- **Type**: `string`
- **Description**: Name of Key Vault secret storing VM admin password
- **Default**: `'vm-admin-password'`
- **Constitution**: Configurable per FR-012

### `vmSize`
- **Type**: `string`
- **Description**: Azure VM SKU size
- **Default**: `'Standard_D2s_v3'`
- **Constitution**: Must meet FR-002 (2+ cores, 8GB+ RAM)

### `dataD iskSizeGB`
- **Type**: `int`
- **Description**: Size of data disk in GB
- **Default**: `500`
- **Constitution**: Fixed per FR-004

### `fileShareName`
- **Type**: `string`
- **Description**: Name of Azure Files share
- **Default**: `'fs-legacyvm'`
- **Constraints**: 3-63 lowercase alphanumeric, hyphens

### `fileShareQuotaGB`
- **Type**: `int`
- **Description**: File share quota in GB
- **Default**: `100`

### `logAnalyticsRetentionDays`
- **Type**: `int`
- **Description**: Log retention in days
- **Default**: `30`

## Optional Parameters

### `environment`
- **Type**: `string`
- **Description**: Environment tag value
- **Default**: `'Production'`

### `tags`
- **Type**: `object`
- **Description**: Additional resource tags
- **Default**: `{}`

## Example main.bicepparam

```bicep
using './main.bicep'

param workloadName = 'legacyvm'
param location = 'westus3'
param availabilityZone = 1
param vmAdminUsername = 'vmadmin'
param vmAdminSecretName = 'vm-admin-password'
param vmSize = 'Standard_D2s_v3'
param dataDiskSizeGB = 500
param fileShareName = 'fs-legacyvm'
param fileShareQuotaGB = 100
param logAnalyticsRetentionDays = 30
param environment = 'Production'
```
