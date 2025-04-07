---
title: Module Changelog Generation
---

Changelogs are crucial in software development as they provide a detailed and chronological record of all notable changes made to a project. This documentation helps developers, project managers, and users to track the progress of the project, understand the evolution of features, and identify when and where bugs were introduced or fixed. Changelogs also facilitate better communication within the development team and with stakeholders, ensuring everyone is aware of the latest updates and improvements. Additionally, they are essential for maintaining transparency and accountability in the development process.

{{< tabs title="Changelog examples" >}}
  {{% tab title="new release template" %}}

## new release template

This template should be included right after the `# Changelog` line in any PR that changes the version number of a module.

```text
## <version>

### Changes

- this changed
- and this also

### Breaking Changes

- none

```

  {{% /tab %}}
  {{% tab title="changelog for a PR" %}}

## changelog for a PR

The current version changes are inserted after the opening heading and adjusted acording to the changes in the PR.

```text
# Changelog

## 0.2.1

### Changes

- Updated the referenced AVM common types
- The recently introduced minCPU parameter is now applied

### Breaking Changes

- none

## 0.2.0

### Changes

- Implemented the minCPU parameter
- Updated the referenced VirtualNetwork module
- Updated the referenced AVM common types

### Breaking Changes

- The minCPU parameter is mandatory

## 0.1.0

### Changes

- Initial Release

### Breaking Changes

- none

```
  {{% /tab %}}
{{% /tabs %}}

## Generation process

Whenever the version of a (sub-)module is increased (major, minor or patch), static tests ensure the existance of

1. a `CHANGELOG.md` file in the modules root directory
2. the changelog file contains a section '## \<new-version>' with two sections
    - Changes
    - Breaking Changes

### CI pipelines

Whenever code is being checked in, the module's specific test is triggered (if the corresponding action is not deactivated).

1. avm.[res|ptn|utl].[provider-namespace].[resource-type] - the default [module pipeline]({{% siteparam base %}}/contributing/bicep/ci-environment/pipeline-design/#module-pipelines)
2. avm.template.module - triggered by the above workflow with module specific parameters
    1. static validation tests, which make sure the CHANGELOG.md is well-formatted

![GitHub Commit message]({{% siteparam base %}}/images/bicep-ci/gh-changelog-commit.png?width=400px)
