---
title: SNFR7 - Idempotency Tests
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: ["Class-Shared","Type-NonFunctional","Category-Testing","Language-Shared","Enforcement-MUST","Persona-Owner","Persona-Contributor","Lifecycle-Maintenance"]
type: "posts"
priority: 80
---

#### ID: SNFR7 - Category: Testing - Idempotency Tests

Modules **MUST** implement idempotency end-to-end (deployment) testing. E.g. deploying the module twice over the top of itself.

Modules **SHOULD** pass the idempotency test, as we are aware that there are some exceptions where they may fail as a false-positive or legitimate cases where a resource cannot be idempotent.

For example, Virtual Machine Image names must be unique on each resource creation/update.
