---
title: Changelog Generation
---

Changelogs are crucial in software development as they provide a detailed and chronological record of all notable changes made to a project. This documentation helps developers, project managers, and users to track the progress of the project, understand the evolution of features, and identify when and where bugs were introduced or fixed. Changelogs also facilitate better communication within the development team and with stakeholders, ensuring everyone is aware of the latest updates and improvements. Additionally, they are essential for maintaining transparency and accountability in the development process.

{{< tabs title="Changelog examples" >}}
  {{% tab title="new release template" %}}

## new release template

This template should be included in any PR that changes the version number of a module.

```
## unreleased

New Features

- new feature

Changes

- this changed
- and this also

Bugfixes

- the deployment does now deploy with the correct settings

Breaking Changes

- none
```

  {{% /tab %}}
  {{% tab title="changelog for a PR" %}}

## changelog for a PR

The 'unreleased' template is inserted after the opening heading and adjusted acording to the changes in the PR.

```
# Changelog

## unreleased

Changes

- Updated the referenced AVM common types

Bugfix

- The recently introduced minCPU parameter is now applied

## 0.2.0 (2024-10-10)

New Features

- Implemented the minCPU parameter

Changes

- Updated the referenced VirtualNetwork module
- Updated the referenced AVM common types

Breaking Changes

- The minCPU parameter is mandatory

## 0.1.0 (2024-10-1)

New Features

- Initial Release

```

  {{% /tab %}}

  {{% tab title="fully generated changelog" %}}

## fully generated changelog

While merging and publishing the PR, the changelog is adjusted to include the now changed version and the date of the merge.

```
# Changelog

## 0.2.1 (2024-10-11)

Changes

- Updated the referenced AVM common types

Bugfix

- The recently introduced minCPU parameter is now applied

## 0.2.0 (2024-10-10)

New Features

- Implemented the minCPU parameter

Changes

- Updated the referenced VirtualNetwork module
- Updated the referenced AVM common types

Breaking Changes

- The minCPU parameter is mandatory

## 0.1.0 (2024-10-1)

New Features

- Initial Release

```

  {{% /tab %}}
{{% /tabs %}}

## Generation process

Whenever the version of a module is increased (major, minor or patch), static tests ensure the existance of

1. a `CHANGELOG.md` file in the modules root directory
2. the file contains a section 'unreleased' with four sections
    - New Features
    - Changes
    - Bugfixes
    - Breaking Changes

When the PR is being merged, the content of the changelog is adjusted accordingly and filling the new version number as well as the date.
