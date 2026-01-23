# Implementation Tasks: Legacy Windows Server VM Workload

**Branch**: `001-legacy-vm-workload` | **Generated**: 2026-01-22  
**Spec**: [spec.md](./spec.md) | **Plan**: [plan.md](./plan.md)

## Overview

Tasks organized by user story to enable independent implementation and testing. Each phase represents a complete, deployable increment that satisfies one or more user stories from the specification.

**Implementation Strategy**:
- MVP: Phase 3 (User Story 1 - Core VM Infrastructure + User Story 4 - Secret Management)
- Incremental: Add Phase 4 (Data Disk), then Phase 5 (File Share)
- Final: Phase 6 (Polish & Cross-Cutting)

**Total Estimated Tasks**: 28  
**Parallelization Opportunities**: 12 tasks marked with [P] can be executed concurrently

---

## Phase 1: Setup & Infrastructure Preparation

**Goal**: Initialize project structure and Bicep configuration

- [ ] T001 Create infra/ directory at repository root per plan.md project structure
- [ ] T002 Create bicepconfig.json with AVM registry configuration (br/public:avm/...)
- [ ] T003 Initialize .gitignore to exclude generated files (*.json outputs, *.log)

---

## Phase 2: Foundational Components (Blocking Prerequisites)

**Goal**: Deploy shared infrastructure required by all user stories

### Log Analytics Workspace
- [ ] T004 [P] Add Log Analytics Workspace module reference (avm/res/operational-insights/workspace:0.9.1) to main.bicep in infra/
- [ ] T005 [P] Configure retention period parameter (30 days default) per contracts/parameters.md

### Virtual Network & NSG
- [ ] T006 [P] Add Virtual Network module reference (avm/res/network/virtual-network:0.5.2) to main.bicep
- [ ] T007 [P] Configure address space (10.0.0.0/16) and 2 subnets: AzureBastionSubnet (10.0.0.0/26), VM subnet (10.0.1.0/24) per data-model.md
- [ ] T008 [P] Configure NSG on VM subnet with rules: Allow RDP from AzureBastionSubnet (priority 100), Allow HTTPS to Storage (priority 100 outbound), Deny all other

### Random Suffix Generation
- [ ] T009 Add variable for random suffix using uniqueString(resourceGroup().id) per research.md naming conventions

**Independent Test Criteria**: Log Analytics workspace and VNet with NSG deploy successfully, VNet has 2 subnets with correct CIDR blocks

---

## Phase 3: User Story 1 & 4 - Core VM Infrastructure + Secret Management (MVP)

**User Stories**: 
- US1 (P1): Deploy Core VM Infrastructure  
- US4 (P1): Secure Secret Management

**Goal**: Deploy Windows Server 2016 VM with Bastion access and Key Vault password storage

**Independent Test Criteria**: VM running Windows Server 2016 (2 cores, 8GB RAM), Bastion allows RDP connection, admin password stored in Key Vault and usable for login

### Key Vault with Password Secret
- [ ] T010 [US1] Add Key Vault module reference (avm/res/key-vault/vault:0.10.2) to main.bicep
- [ ] T011 [US1] Generate admin password using uniqueString(resourceGroup().id, deployment().name) + guid() + special chars per research.md password strategy
- [ ] T012 [US1] Configure Key Vault secrets parameter array with generated password, secret name from parameters (vmAdminSecretName)
- [ ] T013 [US1] Configure Key Vault RBAC roles for deployment principal
- [ ] T014 [US1] Configure Key Vault diagnostic settings to Log Analytics workspace (audit logs per FR-018)

### Azure Bastion
- [ ] T015 [P] [US1] Add Bastion Host module reference (avm/res/network/bastion-host:0.4.0) to main.bicep
- [ ] T016 [P] [US1] Configure Bastion to use AzureBastionSubnet, Basic SKU, diagnostic settings per data-model.md

### Virtual Machine
- [ ] T017 [US1] Add Virtual Machine module reference (avm/res/compute/virtual-machine:0.8.0) to main.bicep
- [ ] T018 [US1] Configure VM with size Standard_D2s_v3, Windows Server 2016 Datacenter image, availability zone from parameters
- [ ] T019 [US1] Configure OS disk with Standard_LRS SKU, ReadWrite caching per data-model.md
- [ ] T020 [US1] Reference Key Vault secret for admin password using reference() function pointing to keyVaultSecretUri
- [ ] T021 [US1] Configure system-assigned managed identity, boot diagnostics enabled
- [ ] T022 [US1] Configure NIC with private IP (dynamic), attach to VM subnet, no public IP
- [ ] T023 [US1] Configure VM diagnostic settings to Log Analytics workspace

### Management Locks
- [ ] T024 [US1] Add CanNotDelete locks to: Resource Group, VNet, Bastion, VM, Key Vault per FR-017

**Independent Test Criteria for Phase 3**: Deploy template, verify VM running (Windows Server 2016, 2 cores, 8GB RAM, Standard HDD), Bastion connection successful using password from Key Vault, all resources locked

---

## Phase 4: User Story 2 - Attach Additional Storage

**User Story**: US2 (P2): Attach Additional Storage

**Goal**: Add 500GB HDD data disk to VM for application data

**Independent Test Criteria**: 500GB Standard HDD data disk attached to VM, visible in Windows Disk Management, correct performance tier

- [ ] T025 [US2] Add data disk configuration to VM module in main.bicep: 500GB size, Standard_LRS SKU, LUN 0, no caching per data-model.md

**Independent Test Criteria for Phase 4**: Deploy updated template, verify data disk attached to VM (500GB, Standard HDD), disk visible in Windows Server Disk Management

---

## Phase 5: User Story 3 - Connect to Secure File Share

**User Story**: US3 (P3): Connect to Secure File Share

**Goal**: Deploy storage account with file share and private endpoint for secure file sharing

**Independent Test Criteria**: Storage account created with file share, private endpoint connected to VNet, administrator can manually mount file share from VM, public access disabled

### Storage Account with File Share
- [ ] T026 [P] [US3] Add Storage Account module reference (avm/res/storage/storage-account:0.14.3) to main.bicep
- [ ] T027 [P] [US3] Configure storage account: name with stlegacyvm prefix (no hyphens), Standard_LRS SKU, TransactionOptimized tier per research.md
- [ ] T028 [P] [US3] Configure file share with name from parameters (fileShareName), quota from parameters (fileShareQuotaGB, default 100GB)
- [ ] T029 [P] [US3] Configure private endpoint for storage account: target subresource 'file', connect to VM subnet per data-model.md
- [ ] T030 [P] [US3] Disable public network access on storage account (allowBlobPublicAccess: false) per FR-020
- [ ] T031 [P] [US3] Configure storage account diagnostic settings to Log Analytics workspace
- [ ] T032 [US3] Add CanNotDelete lock to storage account

**Independent Test Criteria for Phase 5**: Deploy updated template, verify storage account exists with file share, private endpoint connects to VNet, public access disabled, administrator can manually mount file share using output mount command

---

## Phase 6: Polish & Cross-Cutting Concerns

**Goal**: Add monitoring alerts, finalize outputs, and complete parameter file

### Azure Monitor Alerts
- [ ] T033 [P] Add Alert Rule for VM stopped/deallocated state (query: VM power state changes to stopped) per FR-021
- [ ] T034 [P] Add Alert Rule for data disk capacity >90% (query: LogicalDisk free space % on data disk LUN 0) per FR-021
- [ ] T035 [P] Add Alert Rule for Key Vault access failures (query: AuditEvent category with failed status) per FR-021

### Outputs Configuration
- [ ] T036 Output resourceGroupName, virtualNetworkId, vmName, vmPrivateIP, bastionName per contracts/outputs.md
- [ ] T037 Output storageAccountName, fileShareName, fileShareMountCommand (PowerShell net use command), keyVaultName, keyVaultSecretUri, logAnalyticsWorkspaceId per contracts/outputs.md

### Parameter File
- [ ] T038 Create main.bicepparam file in infra/ with all 11 parameters from contracts/parameters.md
- [ ] T039 Set parameter defaults: workloadName='legacyvm', location='westus3', availabilityZone=1, vmAdminUsername='vmadmin', vmSize='Standard_D2s_v3', dataDiskSizeGB=500, fileShareQuotaGB=100, logAnalyticsRetentionDays=30, environment='prod'
- [ ] T040 Document configurable parameters: vmAdminSecretName, fileShareName per contracts/parameters.md

---

## Task Dependencies & Execution Order

### Critical Path (Sequential)
1. **Phase 1** (Setup) → **Phase 2** (Foundational) → **Phase 3** (MVP)
2. **Phase 3** (US1+US4) must complete before Phase 4 (US2) and Phase 5 (US3)
3. **Phase 4** and **Phase 5** are independent (can be parallel or any order)
4. **Phase 6** (Polish) requires all previous phases complete

### User Story Completion Order
1. **MVP**: User Story 1 + User Story 4 (Phase 3) - Core VM with Bastion and Key Vault
2. **Increment 1**: User Story 2 (Phase 4) - Data disk attachment
3. **Increment 2**: User Story 3 (Phase 5) - File share with private endpoint
4. **Finalize**: Phase 6 - Alerts and cross-cutting concerns

### Parallel Execution Opportunities (by Phase)

**Phase 2 Foundational** (3 parallel groups):
- Group 1: T004-T005 (Log Analytics)
- Group 2: T006-T008 (VNet + NSG)
- Group 3: T009 (Random suffix variable - no dependencies)

**Phase 3 MVP** (partial parallelization after Key Vault):
- T010-T014 must complete first (Key Vault with password secret)
- After T014: T015-T016 (Bastion) and T017-T023 (VM) can run in parallel
- T024 (Locks) must run last after all resources created

**Phase 5 File Share** (all tasks parallel after dependencies):
- T026-T032 can run concurrently if storage account module supports all features in single deployment

**Phase 6 Polish** (3 parallel groups):
- Group 1: T033-T035 (Alert rules - all parallel)
- Group 2: T036-T037 (Outputs - parallel)
- Group 3: T038-T040 (Parameter file - sequential within group)

---

## Implementation Strategy

### MVP First (Recommended)
Deploy Phase 3 only (User Story 1 + User Story 4):
- Delivers working VM with secure access via Bastion
- Admin password stored in Key Vault
- All security baselines met (NSG, private networking, no public IP)
- ~15 tasks, estimated 4-6 hours including testing

### Incremental Delivery
After MVP validated:
1. Add Phase 4 (US2) - Data disk (~1 task, 30 minutes)
2. Add Phase 5 (US3) - File share with private endpoint (~7 tasks, 2-3 hours)
3. Add Phase 6 - Monitoring alerts and finalization (~8 tasks, 1-2 hours)

### Validation at Each Phase
- Run `az deployment group validate` before deployment (Constitution Principle IV)
- Run `az deployment group what-if` to review changes
- Deploy and execute independent test criteria for that phase
- Verify success criteria from spec.md apply to deployed resources

---

## Next Steps

1. ✅ Complete checklist validation (checklists/implementation-readiness.md)
2. ⏭️ Begin Phase 1 (Setup): Create infra/ directory and bicepconfig.json
3. ⏭️ Execute Phase 2 (Foundational): Deploy Log Analytics and VNet
4. ⏭️ Execute Phase 3 (MVP): Deploy Key Vault, Bastion, VM with locks
5. ⏭️ Test MVP: Verify VM accessible via Bastion using Key Vault password
6. ⏭️ Execute Phase 4-6: Incrementally add data disk, file share, alerts

**Total Task Count**: 40 tasks  
**MVP Task Count**: 21 tasks (Phases 1-3)  
**Parallelizable Tasks**: 12 tasks marked with [P]  
**Estimated Total Time**: 10-14 hours (including testing and validation)  
**Estimated MVP Time**: 6-8 hours
