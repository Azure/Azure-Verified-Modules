# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/templates/commands/plan.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. For Azure IaC projects, focus on infrastructure details.
-->

**IaC Language**: Bicep (latest stable version)  
**Module Framework**: Azure Verified Modules (AVM) only  
**Target Region**: westus3 (US West 3)  
**Deployment Tool**: Azure CLI (`az deployment group`)  
**Validation Required**: ARM validation + what-if analysis before every deployment  
**Workload Type**: Legacy compliance-retained workload  
**High Availability**: Not required  
**Disaster Recovery**: Not required  
**Scalability Requirements**: Not required  
**Security Baseline**: Azure Security Center recommendations + diagnostic logging mandatory  
**Naming Convention**: {resourceType}-{purpose}-{random4-6chars}  
**Compliance Tags**: [Specify compliance identifiers, e.g., "legacy-retention"]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [ ] **I. Infrastructure-as-Code First**: All resources defined in Bicep (no manual Portal changes)
- [ ] **II. AVM-Only Modules**: Using Azure Verified Modules exclusively (document exceptions)
- [ ] **III. Validation Before Deployment**: ARM validation + what-if planned before deployment
- [ ] **IV. Security & Reliability First**: Diagnostic logs, managed identities, NSGs, least privilege
- [ ] **V. Minimal Naming with Type ID**: Names follow {type}-{purpose}-{random} pattern
- [ ] **VI. Region Standardization**: Deploying to westus3 (document exceptions)

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
```For Azure IaC projects, use the structure below as the foundation.
-->

```text
# Infrastructure-as-Code structure (Azure/Bicep)
infra/
├── main.bicep           # Main deployment template
├── main.bicepparam      # Environment parameters
├── modules/             # Custom modules (if any - prefer AVM)
│   └── [custom-module]/ # Only when AVM unavailable
└── docs/
    ├── architecture.md  # Resource relationship diagram
    └── deployment.md    # Deployment instructions

# Optional: Custom scripts (only when Bicep insufficient)
scripts/
├── post-deployment/     # Configuration scripts
└── validation/          # Custom validation scripts

# Documentation
README.md                # Project overview and quickstart
CHANGELOG.md             # Infrastructure change history
```

**Structure Decision**: Infrastructure-as-Code repository for Azure workload using Bicep and AVM modules. Single template approach with ARM-managed dependencies.
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
