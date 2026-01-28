---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Infrastructure**: `infra/` at repository root (main.bicep, main.bicepparam)
- **Custom Modules**: `infra/modules/` (only when AVM unavailable)
- **Scripts**: `scripts/` (post-deployment, validation - only when Bicep insufficient)
- **Documentation**: `infra/docs/` (architecture diagrams, deployment guides)

<!--
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.

  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/

  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment

  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic Bicep structure

- [ ] T001 Create infrastructure directory structure (infra/, infra/docs/, scripts/)
- [ ] T002 Initialize main.bicep and main.bicepparam files
- [ ] T003 [P] Configure bicepconfig.json with AVM module aliases
- [ ] T004 [P] Create README.md with deployment instructions
- [ ] T005 [P] Setup resource naming convention variables in Bicep

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T006 Define resource group parameter in main.bicep
- [ ] T007 [P] Add AVM module for Log Analytics Workspace (centralized logging)
- [ ] T008 [P] Add AVM module for Key Vault (secrets management)
- [ ] T009 [P] Configure diagnostic settings output from Log Analytics
- [ ] T010 Add location parameter (default: 'westus3')
- [ ] T011 Define naming convention variables (resource type + random suffix)
- [ ] T012 [P] Configure compliance tags as variables

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP
infrastructure this story delivers]

**Independent Test**: [How to verify this infrastructure works - e.g., "Deploy to test resource group and verify resources created"]

### Validation for User Story 1 (MANDATORY - Constitution Principle III) ⚠️

> **NOTE: Run validation BEFORE deployment, ALWAYS**

- [ ] T013 [US1] Run `bicep build` to compile main.bicep and check for syntax errors
- [ ] T014 [US1] Run `az deployment group validate` against main.bicep with parameters
- [ ] T015 [US1] Run `az deployment group what-if` to preview infrastructure changes
- [ ] T016 [US1] Review validation output and resolve any errors or warnings

### Implementation for User Story 1

- [ ] T017 [P] [US1] Research and identify appropriate AVM module for [Resource Type 1]
- [ ] T018 [P] [US1] Research and identify appropriate AVM module for [Resource Type 2]
- [ ] T019 [US1] Add AVM module declaration for [Resource 1] in main.bicep
- [ ] T020 [US1] Configure parameters for [Resource 1] (name, location, SKU, etc.)
- [ ] T021 [US1] Add diagnostic settings for [Resource 1] (send to Log Analytics)
- [ ] T022 [US1] Add AVM module declaration for [Resource 2] in main.bicep
- [ ] T023 [US1] Configure managed identity for [Resource 2] (no connection strings)
- [ ] T024 [US1] Add Network Security Group rules for [Resource 2] (least privilege)
- [ ] T025 [US1] Configure resource tags (compliance identifiers)
- [ ] T026 [US1] Add outputs for deployed resource IDs and endpoints

### Deployment for User Story 1

- [ ] T027 [US1] Deploy to test resource group using `az deployment group create`
- [ ] T028 [US1] Verify all resources created successfully in Azure Portal
- [ ] T029 [US1] Verify diagnostic logs flowing to Log Analytics Workspace
- [ ] T030 [US1] Verify Azure Security Center compliance checks pass
- [ ] T031 [US1] Document deployment outcomes in infra/docs/deployment.md

**Checkpoint**: At this point, User Story 1 infrastructure should be fully deployed and validated
**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T018 [P] [US2] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T019 [P] [US2] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 2

- [ ] T020 [P] [US2] Create [Entity] model in src/models/[entity].py
- [ ] T021 [US2] Implement [Service] in src/services/[service].py
- [ ] T022 [US2] Implement [endpoint/feature] in src/[location]/[file].py
- [ ] T023 [US2] Integrate with User Story 1 components (if needed)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T024 [P] [US3] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T025 [P] [US3] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 3

- [ ] T026 [P] [US3] Create [Entity] model in src/models/[entity].py
- [ ] T027 [US3] Implement [Service] in src/services/[service].py
- [ ] T028 [US3] Implement [endpoint/feature] in src/[location]/[file].py

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests (if requested) in tests/unit/
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
  - Developer A: User Story 1
  - Developer B: User Story 2
  - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
