---
title: Publishing workflow definition
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---

{{< toc >}}


# Process overview

Upon merge to main, the CI environment executes several steps to ultimately publish a new module version into the Public Bicep Registry's Container Registry:

These are
- Static test execution
  - Compliance tests
  - PSRule/WAF-alignment tests
- Deployment test execution
- Publishing 

where each stage only moves onto the next if all previous stages succeeded. 