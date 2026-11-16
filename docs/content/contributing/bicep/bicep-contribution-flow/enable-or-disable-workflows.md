---
title: GitHub Actions in Forks
description: GitHub Actions for Bicep module contributions
---

Microsoft FTEs must create branches in the upstream `Azure/bicep-registry-modules` repository, not forks. External contributors without write access can contribute from a fork. GitHub Actions are disabled by default on new forks; enable them from the fork's **Actions** tab if you need to run checks there.

The shared PR check runs on upstream pull requests. FTEs can request deployment tests on their same-repository PR with the `PR: Run E2E Tests` label. Fork PRs do not receive deployment tests through that label. Follow the [release-branch handoff]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/#running-e2e-for-external-contributions) only when an external contribution needs E2E testing; review source code and workflow changes for security before using the shared handoff command. Never expose secrets to untrusted fork code.

For local checks and optional deployment tests, see [Validate Module Locally]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally/).
