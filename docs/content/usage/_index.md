---
title: AVM Usage Guide
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
---


## Bicep

### Usage scenarios

1. **Direct consumption**: Using AVMs through the public registry
2. **Air gapping**: Using AVMs through a synchronized internal/private registry
    - Absolutely no changes/customization to any modules. Take them as is.
    - Reference public registry (1) or private registry (2)
3. **Source-controlling**: Using AVMs through an internal/private repository - aka **inner sourcing** **OR** through your own public repository - aka **open sourcing/forking**
    - You have full control over your own repository (public or private) - this includes responsibilities of pulling from upstream, resolving conflicts
    - You can (optionally) publish modules
      - into your private registry, OR
      - into your own public registry, OR
      - as template specs

### Deployment options

- "traditional" deployment (New-AzDeployment)
- deployment stacks (~New-AzDeploymentStackDeployment)

### Orchestration options

- Template-orchestrated deployments
- Pipeline orchestrated deployments

## Terraform

Main use cases.
Using AVMs through the public registries (aka direct consumption)
Absolutely no changes/customization to any modules. Take them as is.
Using AVMs through an internal/private repository - aka inner sourcing OR through your own public repository - aka open sourcing/forking
You have full control over your own repository (public or private) - this includes responsibilities of pulling from upstream, resolving conflicts
You can either
publish your version of these modules in the Terraform public registry, OR
you can (optionally) publish modules into your private registry (requires Terraform Enterprise), OR
you can directly reference a git tagged version of your module from your own repository

Orchestration options:
template orchestrated
pipeline orchestrated

Consumption/referencing options
reference your version of these modules in the Terraform public registry, OR
reference modules into your private registry (requires Terraform Enterprise)
reference local files from the repo
