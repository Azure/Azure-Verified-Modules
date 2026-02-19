<!--
Sync Impact Report - Version 1.0.0 (Initial Release)
Version: N/A → 1.0.0 (MAJOR - Initial constitution establishment)
Change Type: Initial Release

Principles Defined:
  ✅ I. Terraform-First Infrastructure
  ✅ II. AVM-Only Modules (Terraform Registry)
  ✅ III. Security & Reliability (NON-NEGOTIABLE)
  ✅ IV. Single-Template Pattern (Terraform root module)
  ✅ V. Validation-First Deployment (terraform validate + plan)

Sections Added:
  ✅ Deployment Standards
  ✅ Project Constraints
  ✅ Naming Convention

Templates Status:
  ⚠ plan-template.md - Update Constitution Check for Terraform workflow (init → validate → plan → apply)
  ⚠ spec-template.md - Update infrastructure requirements for .tf file patterns and state management
  ⚠ tasks-template.md - Update task patterns for Terraform validation, AVM module sourcing, and security scanning

Follow-up Actions:
  - Update plan-template.md Technical Context to include Terraform version and required providers
  - Ensure spec-template.md reflects Terraform state management and backend configuration requirements
  - Update tasks-template.md to include terraform init, validate, fmt, plan task patterns
  - Add Terraform-specific linting (tflint, tfsec, checkov) to setup phase tasks
  - Document Terraform backend configuration (Azure Storage for remote state) in project README
  - Add .terraform, .tfstate, .tfvars patterns to .gitignore
-->

# Azure Verified Modules Legacy Workload Constitution

## Core Principles

### I. Terraform-First Infrastructure
Every Azure resource MUST be defined as Infrastructure-as-Code in Terraform configuration files before any alternative approach is considered. Custom scripts (PowerShell, Azure CLI, Bash) are permitted ONLY when Terraform providers cannot accomplish the requirement.

**Rationale**: Declarative infrastructure ensures repeatability, version control, audit trails, and compliance documentation. Terraform's state management provides idempotent operations and built-in dependency resolution through resource graph analysis.

**Requirements**:
- All Azure resources declared in Terraform `.tf` files in project root or modules
- Single root module paradigm - let Terraform manage orchestration and dependencies via implicit resource references
- Custom scripts require explicit justification documenting why Terraform AzureRM provider cannot solve the need
- All infrastructure changes tracked in version control
- Terraform state stored remotely in Azure Storage Account with state locking enabled (blob container + lease)
- Use Terraform workspaces or separate state files for environment separation (dev, prod)
- `.terraform/`, `*.tfstate`, `*.tfstate.backup`, `*.tfvars` (except example files) excluded from version control

### II. AVM-Only Modules
All Terraform modules MUST be sourced exclusively from Azure Verified Modules (AVM) for Terraform. No custom or third-party Terraform modules are permitted unless an AVM module does not exist for the required resource type.

**Rationale**: AVM Terraform modules are Microsoft-maintained, tested against Azure best practices, include security hardening, follow consistent interfaces, and receive ongoing updates for provider changes and new Azure features.

**Requirements**:
- Use AVM resource modules (`Azure/avm-res-*`) from Terraform Registry for all supported Azure resources
- Use AVM pattern modules (`Azure/avm-ptn-*`) from Terraform Registry for multi-resource patterns
- Reference modules from official Terraform Registry source: `registry.terraform.io/Azure/avm-*`
- Pin module versions explicitly using pessimistic constraint (e.g., `version = "~> 0.1.0"`) - no floating latest versions
- If AVM module unavailable, document gap in ADR (Architecture Decision Record) and follow AVM authoring standards for local module
- Review and update AVM module versions quarterly minimum - document breaking changes in release notes review

**Example AVM Module Reference**:
```hcl
module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "~> 0.1.0"
  
  # Module inputs per AVM interface
}
```

### III. Security & Reliability (NON-NEGOTIABLE)
Security and reliability best practices MUST be followed under all circumstances. This principle supersedes convenience, development velocity, and cost optimization.

**Rationale**: Legacy workloads retained for compliance reasons carry regulatory and legal obligations. Security breaches or reliability failures create compliance violations with potential legal ramifications.

**Requirements**:
- Managed identities required - no service principal credentials in Terraform code or variable files
- All secrets stored in Azure Key Vault - no plaintext secrets in `.tf`, `.tfvars`, or state files
- Use `sensitive = true` attribute for all secret outputs and variables
- Network security groups (NSGs) with explicit deny-by-default rules
- Azure Policy compliance validated before deployment (`terraform plan` must show policy compliance)
- Diagnostic settings and logging enabled on all supported resources (Activity Logs, Resource Logs)
- Resource locks (`CanNotDelete`) applied to prevent accidental deletion of compliance-critical resources
- Encryption at rest enabled (Microsoft-managed or customer-managed keys as appropriate)
- TLS 1.2+ required for all network communication (enforce via Azure Policy or resource properties)
- Principle of least privilege for all RBAC assignments (use built-in roles, no custom roles without justification)
- Static security analysis with `tfsec` or `checkov` in CI/CD pipeline - HIGH/CRITICAL findings block merge
- No hardcoded resource IDs or subscription IDs - use `data` sources or variables

### IV. Single-Template Pattern
All infrastructure for the workload MUST be defined in a single Terraform root module with Terraform managing dependencies and deployment order. Multi-stage deployments are permitted only when Terraform constraints (circular dependencies, provider limitations) make single-root infeasible.

**Rationale**: Single root module ensures atomic deployment, eliminates manual orchestration errors, simplifies rollback, and provides complete infrastructure visibility in one artifact. Terraform's dependency graph automatically determines execution order.

**Requirements**:
- One root module with `main.tf`, `variables.tf`, `outputs.tf`, and `versions.tf` (or combined files by preference)
- Use `depends_on` sparingly - rely on Terraform implicit dependency resolution via resource attribute references
- Child module composition for organizational clarity - all child modules instantiated in root module
- Separate `.tfvars` files for environment-specific values (e.g., `dev.tfvars`, `prod.tfvars`)
- If multi-stage required, document Terraform limitation necessitating split (rare - most circular dependencies solvable with proper design)
- No imperative orchestration scripts chaining multiple `terraform apply` commands

**Example Root Module Structure**:
```
terraform/
├── main.tf           # Primary resource declarations and module calls
├── variables.tf      # Input variable definitions
├── outputs.tf        # Output value definitions
├── versions.tf       # Terraform and provider version constraints
├── backend.tf        # Remote state backend configuration
├── dev.tfvars        # Development environment values
├── prod.tfvars       # Production environment values
└── modules/          # Local child modules (only if AVM unavailable)
    └── custom/
```

### V. Validation-First Deployment
Every deployment MUST execute Terraform validation (`terraform validate`) and plan review (`terraform plan`) before actual apply. Deployments without successful validation and plan approval are prohibited.

**Rationale**: Validation catches syntax errors, type mismatches, and configuration issues. Plan preview catches logical errors, permission issues, policy violations, and unintended changes, preventing destructive actions and partial deployments.

**Requirements**:
- `terraform init` executed to initialize providers and backend
- `terraform fmt -check` executed to enforce code formatting (must pass before deployment)
- `terraform validate` executed and must return success before plan
- `terraform plan -out=plan.tfplan` executed for every deployment - output must be reviewed and approved
- Plan shows no unexpected resource deletions or replacements (unless explicitly intended and documented)
- Validation failures or unexpected plan changes block deployment pipeline - no manual override without incident review
- Plan file (`plan.tfplan`) stored as artifact in CI/CD for audit trail (encrypted if sensitive data present)
- Apply MUST use plan file: `terraform apply plan.tfplan` (no ad-hoc apply without plan)
- Plan diff documented in deployment logs for compliance audit trail

**Deployment Workflow**:
1. `terraform init -backend-config=backend-prod.hcl`
2. `terraform fmt -check -recursive`
3. `terraform validate`
4. `terraform plan -var-file=prod.tfvars -out=plan.tfplan`
5. **GATE**: Human review and approval of plan output
6. `terraform apply plan.tfplan`

## Deployment Standards

### Region & Availability
- **Target Region**: US West 3 (`westus3`) for all resources
- **High Availability**: Not required (legacy workload, compliance retention only)
- **Disaster Recovery**: Not required
- **Scalability**: Not required (fixed capacity sufficient)

**Rationale**: This is a legacy workload retained for compliance and legal record-keeping. Active user workloads have migrated to modern platforms. Fixed-region, single-instance deployments are appropriate and cost-effective.

**Terraform Implementation**:
- Use `location = "westus3"` for all resources (or variable `var.location` with default `"westus3"`)
- No zone redundancy, geo-replication, or auto-scaling configurations
- Accept default SKUs optimized for cost over high availability (e.g., Standard vs Premium)

### Naming Convention
Resource names MUST follow this pattern: `<resourceTypeAbbreviation>-<workloadName>-<randomSuffix>`

**Requirements**:
- Resource type abbreviation per [Azure naming best practices](https://learn.microsoft.com/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations) (e.g., `st` for Storage Account, `kv` for Key Vault, `vm` for Virtual Machine)
- Workload name: `avmlegacy` (or feature-specific descriptor)
- Random suffix: minimum characters needed for global uniqueness (e.g., 6-character alphanumeric generated via `random_string` resource)
- Respect Azure resource type character limits and restrictions:
  - Storage Account: 24 chars max, lowercase alphanumeric only, globally unique
  - Key Vault: 3-24 chars, alphanumeric and hyphens, globally unique
  - Resource Group: 1-90 chars, alphanumeric, underscores, hyphens, periods
- Use Terraform `random_string` or `random_id` resource to generate suffix consistently across deployments
- Document abbreviations in README or add comments in code

**Terraform Implementation Example**:
```hcl
resource "random_string" "unique_suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  workload_name = "avmlegacy"
  location_abbr = "wus3"  # westus3 abbreviation
  
  # Resource names following convention
  storage_account_name = "st${local.workload_name}${random_string.unique_suffix.result}"  # max 24 chars
  key_vault_name       = "kv-${local.workload_name}-${random_string.unique_suffix.result}"
  resource_group_name  = "rg-${local.workload_name}-${local.location_abbr}"
}

resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = "westus3"
}
```

**Examples**:
- `stavmlegacy8k3m9x` (Storage Account - 18 chars)
- `kv-avmlegacy-8k3m9x` (Key Vault - 20 chars)
- `rg-avmlegacy-wus3` (Resource Group)
- `vm-avmlegacy-001` (Virtual Machine - numeric suffix for multiple instances)

## Project Constraints

### Legacy Workload Context
This infrastructure supports a **legacy Azure workload** retained exclusively for compliance, regulatory, and legal record-keeping purposes. Active business operations have migrated off this system.

**Implications**:
- Cost optimization prioritized (single instances, no redundancy beyond Azure platform defaults)
- Change frequency low (quarterly patches and security updates only)
- User activity minimal (compliance audits, occasional data retrieval by legal/audit teams)
- Retention period defined by legal/compliance requirements (document separately in project README or ADR)
- Decommissioning planned when retention period expires (add sunset date if known)

**Terraform Impact**:
- Use smaller SKUs and tiers (Standard vs Premium) where compliance allows
- No auto-scaling configurations needed
- Simplified networking (single VNet, minimal subnets)
- Backup retention aligned with compliance requirements (not business continuity requirements)

### Non-Functional Requirements
- **Performance**: Adequate for infrequent access (no SLA requirements, no performance testing needed)
- **Availability**: Standard Azure platform availability (no custom HA configurations, 99.9% acceptable)
- **Capacity**: Fixed sizing (no auto-scaling, no capacity planning for growth)
- **Compliance**: MUST maintain audit logs (Azure Monitor Logs minimum 90 days), access controls (RBAC), data integrity (checksums, immutability where required)
- **Cost**: Target <$X/month (specify budget if known) - optimize for minimal operational cost
- **Maintenance Window**: Changes allowed during business hours (no 24/7 operations requirement)

## Governance

This constitution is the ultimate authority for all infrastructure decisions, architecture choices, and development practices for this workload. All team members, code reviews, and deployment pipelines MUST verify compliance.

### Amendment Process
1. Proposed changes documented with rationale and impact analysis (create ADR in `docs/decisions/` if significant)
2. Review by infrastructure lead and compliance officer
3. Approval required before amendment merge
4. Version incremented per semantic versioning:
   - **MAJOR**: Principle removal, redefinition, or backward-incompatible governance changes (e.g., switching IaC tools)
   - **MINOR**: New principle added or materially expanded guidance (e.g., adding new security requirement)
   - **PATCH**: Clarifications, corrections, non-semantic improvements (e.g., fixing typos, adding examples)
5. Migration plan required for MAJOR/MINOR changes affecting existing infrastructure (document in amendment PR)
6. All dependent templates and documentation updated atomically with constitution

### Compliance Review
- All pull requests MUST include constitution compliance checklist (see `.github/PULL_REQUEST_TEMPLATE.md`)
- Deployment pipelines MUST validate against principles where automatable:
  - Terraform fmt check (Principle I)
  - AVM module source validation (Principle II)
  - tfsec/checkov security scan (Principle III)
  - Plan approval gate (Principle V)
- Quarterly compliance audit against all principles with findings documented in team wiki/issue tracker
- Violations require remediation plan within 30 days or justified exception with expiration date (document in issue)

### Compliance Checklist (for PRs):
- [ ] All resources defined in Terraform (Principle I)
- [ ] All modules sourced from AVM Terraform Registry (Principle II)
- [ ] Security requirements met: managed identities, Key Vault, NSGs, logging (Principle III)
- [ ] Single root module pattern followed (Principle IV)
- [ ] Deployment includes terraform validate and plan review (Principle V)
- [ ] Naming convention followed (Deployment Standards)
- [ ] Resources deployed to westus3 region (Deployment Standards)
- [ ] No high-availability or disaster recovery features added unnecessarily (Project Constraints)

### Runtime Guidance
For day-to-day development guidance, coding standards, and tooling setup, refer to:
- `.specify/templates/` for specification and planning workflows
- Project `README.md` for Terraform setup, backend configuration, and deployment instructions
- `docs/` directory for additional Terraform patterns, troubleshooting, and Azure-specific guidance

**Version**: 1.0.0 | **Ratified**: 2026-02-18 | **Last Amended**: 2026-02-18
