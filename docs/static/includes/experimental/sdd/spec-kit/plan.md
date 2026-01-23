# Implementation Plan: Legacy Windows Server VM Workload

**Branch**: `001-legacy-vm-workload` | **Date**: 2026-01-22 | **Spec**: [spec.md](./spec.md)
**Input**: Feature specification from `/specs/001-legacy-vm-workload/spec.md`

## Summary

Deploy a Windows Server 2016 VM with secure network isolation, storage, and administrative access for legacy compliance workload. Implementation uses single main.bicep file with AVM modules for all resources: VNet, VM, Bastion, Storage Account with private endpoint, and Key Vault for password management. Admin password generated using uniqueString() and stored via AVM Key Vault secrets feature, then referenced by VM module. ARM incremental deployment mode ensures idempotent infrastructure-as-code with no custom scripts.

## Technical Context

**Language/Version**: Bicep (latest stable version - 0.31.x or higher)
**Primary Dependencies**: Azure Verified Modules (AVM) from `br/public:avm/...` registry
**Storage**: Azure Files (Standard HDD tier), Azure Managed Disks (Standard HDD OS + 500GB data disk)
**Testing**: Azure CLI pre-deployment validation (`az deployment group validate`), ARM What-If analysis
**Target Platform**: Azure US West 3 region, Windows Server 2016 Datacenter
**Project Type**: Infrastructure-as-Code (single template deployment)
**Performance Goals**: N/A (legacy workload maintenance, no performance SLAs)
**Constraints**:
- 100% AVM modules (no custom Bicep resource declarations)
- Single main.bicep + single main.bicepparam file
- No custom scripts (deployment scripts, CSE, etc.)
- ARM incremental mode only (no resource deletion on partial failure)
- Password generation via uniqueString() within Bicep (no external helpers)
- Manual file share mounting post-deployment (no automated mounting)

**Scale/Scope**: Single-VM workload, single resource group, production environment, US West 3 region only

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Pre-Phase 0 Check

| Principle | Requirement | Status | Notes |
|-----------|-------------|--------|-------|
| I. AVM-Only Modules | All resources via AVM modules | ✅ PASS | Plan specifies AVM for all resources |
| II. IaC First | Single Bicep template, no scripts | ✅ PASS | main.bicep only, password via uniqueString() |
| III. Security & Reliability | Managed IDs, private endpoints, locks, logging | ✅ PASS | All security requirements in scope |
| IV. Pre-Deployment Validation | Validate before deploy | ✅ PASS | Validation step mandatory |
| V. Naming & Regional | CAF naming, westus3, zones 1-3 | ✅ PASS | Naming pattern defined, region fixed |

**Gate Decision**: ✅ **PROCEED TO PHASE 0**

All constitutional principles are satisfied by the planned approach. No violations requiring justification.

### Post-Phase 1 Check

*Re-evaluation after completing data model, contracts, and quickstart guide.*

| Principle | Requirement | Status | Evidence |
|-----------|-------------|--------|----------|
| I. AVM-Only Modules | All resources via AVM modules | ✅ PASS | Data model specifies 10 resource types, all mapped to specific AVM modules in research.md (e.g., `avm/res/compute/virtual-machine:0.8.0`, `avm/res/key-vault/vault:0.10.2`). Zero custom Bicep resource declarations. |
| II. IaC First | Single Bicep template, no scripts | ✅ PASS | Quickstart.md confirms deployment via `az deployment group create` with Bicep template. File share mounting documented as manual post-deployment task (no Custom Script Extension). ARM incremental mode for idempotent redeployment. |
| III. Security & Reliability | Managed IDs, private endpoints, locks, logging | ✅ PASS | Data model includes: NSGs, private endpoints, managed identities, encryption at rest, RBAC, CanNotDelete locks, diagnostic logging, Key Vault for secrets. Quickstart validates pre-deployment (`az deployment group validate`). |
| IV. Pre-Deployment Validation | Validate before deploy | ✅ PASS | Quickstart.md Step 4 mandates validation command before deployment (references Constitution Principle IV explicitly). Validation step includes What-If review. |
| V. Naming & Regional | CAF naming, westus3, zones 1-3 | ✅ PASS | Data model entities follow CAF abbreviations + `workloadName` + 6-char random suffix (e.g., `vm-legacyvm-x7k9m`). Parameters contract fixes `location = 'westus3'` (default, no override allowed per constitution). |

**Gate Decision**: ✅ **PROCEED TO PHASE 2**

No new violations introduced during Phase 1 design. All constitution principles remain satisfied. Ready for task breakdown generation.

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command - NOT created by /speckit.plan)
```

### Source Code (repository root)

```text
infra/
├── main.bicep           # Single Bicep template with all AVM module references
├── main.bicepparam      # Parameter file for deployment
└── modules/             # Existing folder (not used for this feature per requirements)
```

**Structure Decision**: Infrastructure-as-Code project structure. Since requirements specify "single main.bicep file with direct AVM module references" and "no local modules", we use a flat structure with main.bicep at repository root (infra/ folder). The existing modules/ folder is not used per user requirements. All infrastructure defined declaratively in one template file, with parameters externalized to main.bicepparam.

## Complexity Tracking

> No constitution violations - this section intentionally left empty per gate check results.

---

## Phase 1 Summary: Design Artifacts Generated

Phase 1 (Design & Contracts) completed successfully with the following deliverables:

### 1. Data Model ([data-model.md](./data-model.md))
- **12 Azure resource entities** defined with complete attributes and relationships
- **Entity Relationship Diagram (ERD)** showing dependencies
- **Deployment order** specified: Resource Group → VNet/NSG → Bastion → Log Analytics → Key Vault (with password secret) → VM with disks → Storage Account → Private Endpoint → Locks → Alert Rules
- **Key entities**: Resource Group, Virtual Network (2 subnets), NSG, Bastion, Virtual Machine (Windows Server 2016), Managed Disks (OS + 500GB data), Storage Account with File Share (100GB HDD), Private Endpoint, Key Vault with password secret, Log Analytics Workspace, Management Locks, Alert Rules (3 types)

### 2. API Contracts ([contracts/](./contracts/))
- **Parameters contract** ([parameters.md](./contracts/parameters.md)): 11 input parameters for main.bicepparam
  - Required: `workloadName`, `vmAdminUsername`, `vmAdminSecretName`
  - Optional with defaults: `location` (westus3), `availabilityZone` (1), `vmSize` (Standard_D2s_v3), `dataDiskSizeGB` (500), `fileShareName`, `fileShareQuotaGB` (100), `logAnalyticsRetentionDays` (30), `environment` (prod)
- **Outputs contract** ([outputs.md](./contracts/outputs.md)): 10 outputs from main.bicep
  - Administrative: `resourceGroupName`, `vmName`, `vmPrivateIP`, `bastionName`, `keyVaultName`, `keyVaultSecretUri`
  - Post-deployment: `fileShareMountCommand` (PowerShell net use command), `storageAccountName`, `fileShareName`, `logAnalyticsWorkspaceId`

### 3. Deployment Guide ([quickstart.md](./quickstart.md))
- **Pre-deployment checklist**: Azure CLI version, login, subscription, quota verification
- **Validation commands**: `az deployment group validate` with What-If review (mandated by Constitution Principle IV)
- **Deployment commands**: Azure CLI and PowerShell examples with timestamped deployment names
- **Post-deployment tasks**:
  - Retrieve VM admin password from Key Vault
  - Connect via Bastion
  - Manually mount file share (PowerShell net use command)
  - Verify diagnostic logging and alerts
- **Troubleshooting guide**: Common errors (quota exceeded, naming conflicts, Bastion issues), incremental redeployment procedure
- **Compliance checklist**: 9-item verification list (locks, logging, private endpoints, alerts, etc.)

### 4. Agent Context Update
- **GitHub Copilot instructions** updated at [.github/agents/copilot-instructions.md](../../.github/agents/copilot-instructions.md)
- **Technologies added**: Bicep (latest stable 0.31.x+), AVM from br/public:avm registry, Azure Files, Azure Managed Disks
- **Project structure** documented for future agent sessions

### Design Decisions Captured
1. **Password generation**: uniqueString() + guid() + special chars within Bicep, stored via AVM Key Vault module's `secrets` parameter array
2. **Network architecture**: 2-subnet VNet (AzureBastionSubnet /26 + VM subnet /24), NSG attached to VM subnet
3. **Storage configuration**: Storage Account with private endpoint, file share mounted manually post-deployment (no Custom Script Extension per IaC-First principle)
4. **Naming convention**: CAF abbreviations + `workloadName` + 6-character random suffix using uniqueString(resourceGroup().id)
5. **Monitoring**: Diagnostic settings to Log Analytics + 3 critical alert rules (VM stopped, disk >90%, Key Vault access failures)

---

## Phase 2 Preview: Task Breakdown (Not Executed)

**Important**: This plan.md document is generated by `/speckit.plan` command and stops after Phase 1 design. Task breakdown is generated separately by `/speckit.tasks` command.

### Expected Phase 2 Outputs (from future /speckit.tasks execution)

**File**: `specs/001-legacy-vm-workload/tasks.md`

**Structure**:
1. **Pre-implementation tasks**
   - Set up repository structure (create infra/ folder)
   - Initialize Bicep configuration (bicepconfig.json with AVM registry)
2. **Core implementation tasks**
   - Create main.bicep template structure
   - Add Resource Group deployment target
   - Add VNet + NSG module references
   - Add Bastion module reference
   - Add Log Analytics Workspace module reference
   - Add Key Vault module reference with password secret generation
   - Add Virtual Machine module reference with password secret reference
   - Add Managed Disks (data disk) module reference
   - Add Storage Account module reference
   - Add Private Endpoint module reference
   - Add Management Locks module references
   - Add Alert Rules module references
   - Configure diagnostic settings for all resources
3. **Parameter file tasks**
   - Create main.bicepparam with all 11 parameters
   - Set defaults per contracts/parameters.md
4. **Testing tasks**
   - Run `az deployment group validate`
   - Review What-If output
   - Deploy to test resource group
   - Execute post-deployment verification (Bastion connection, file share mount, logs, alerts)
5. **Documentation tasks**
   - Update root README.md with deployment instructions
   - Document manual file share mounting procedure
   - Add troubleshooting scenarios

**Task Count Estimate**: 25-30 granular tasks

**Implementation Time Estimate**: 6-8 hours (including testing and troubleshooting)

---

## Next Steps

1. ✅ **Phase 0 Complete**: research.md generated with AVM module mapping, password strategy, network design
2. ✅ **Phase 1 Complete**: data-model.md, contracts/, quickstart.md, agent context updated
3. ⏭️ **Run /speckit.tasks**: Generate detailed task breakdown in tasks.md
4. ⏭️ **Begin implementation**: Create main.bicep and main.bicepparam following task list
5. ⏭️ **Deploy and validate**: Follow quickstart.md deployment procedure

**Branch**: `001-legacy-vm-workload` (already created and checked out)
**Plan Location**: `c:\SOURCE\avm-workload\specs\001-legacy-vm-workload\plan.md`
**Generated Artifacts**:
- `research.md` (296 lines, 8 research sections)
- `data-model.md` (12 entities with ERD and deployment order)
- `contracts/parameters.md` (11 input parameters)
- `contracts/outputs.md` (10 output values)
- `quickstart.md` (deployment guide with 11 steps + troubleshooting)
- `.github/agents/copilot-instructions.md` (agent context updated)

