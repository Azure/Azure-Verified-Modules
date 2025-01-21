---
title: CI environment
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocCollapseSection: true
---

Continuous Integration (CI) pipelines are essential for maintaining the quality and reliability of Azure Verified Modules. These pipelines automate the process of integrating code changes from multiple contributors, running tests, and deploying updates. By automating these tasks, CI pipelines help to catch errors early, ensure that code changes do not introduce new issues, and maintain a consistent codebase.

Using CI pipelines for Azure Verified Modules also facilitates collaboration among developers. Automated testing and integration reduce the time and effort required for manual code reviews and testing, allowing developers to focus on writing high-quality code. Additionally, CI pipelines provide immediate feedback on code changes, enabling developers to address issues promptly. This continuous feedback loop helps to improve the overall quality of the modules and ensures that they meet the rigorous standards expected by Azure users.

The Continuous Integration environment (CI environment) is a set of automation components that are used for continuously validating and publishing module artifacts (Bicep registry repositories, template specs, universal packages). Technically, the CI environment consists of a DevOps platform (GitHub or Azure DevOps) hosting related pipelines and scripts, as well as an Azure environment (Azure AD tenant with management group(s) and subscription(s)) in which the modules are validated by the automation pipelines and scripts.

- [Pipeline design](/Azure-Verified-Modules/contributing/bicep/ci-environment/pipeline-design)
  - [Static validation](/Azure-Verified-Modules/contributing/bicep/ci-environment/static-validation/)
  - [Deployment validation](/Azure-Verified-Modules/contributing/bicep/ci-environment/deployment-validation/)
    - [Deployment history cleanup](/Azure-Verified-Modules/contributing/bicep/ci-environment/deployment-history-cleanup/)
  - Publishing
  - Token replacement
- Pipeline usage
- Bicep configuration
- Troubleshooting
