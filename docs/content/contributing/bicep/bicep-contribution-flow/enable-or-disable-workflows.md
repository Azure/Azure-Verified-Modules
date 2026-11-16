---
title: GitHub Actions in Forks
description: GitHub Actions for Bicep module contributions
---

GitHub Actions are disabled by default on new forks. Enable them from the fork's **Actions** tab if you need to run checks there.

The shared PR check runs on the upstream pull request. Deployment tests are not run automatically for pull requests from forks, even when the `PR: Run E2E Tests` label is present. Coordinate an authorized upstream test run with a maintainer when needed; never expose secrets to untrusted fork code.

For local checks and optional deployment tests, see [Validate Module Locally]({{% siteparam base %}}/contributing/bicep/bicep-contribution-flow/validate-bicep-module-locally/).
