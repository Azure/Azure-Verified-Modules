---
title: Contribution Q&A
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
geekdocToC: 1
---

{{< toc >}}

## Proposing a module

### Where can I submit a new module proposal / request?

To propose a new module, simply create an issue [here][ModuleProposal].
### Can I just propose / create ANY module?

**For example, can I propose one for managed disks or NICs or diagnostic settings? What about patterns?**

No, you cannot propose or create just any module. You can only propose modules that are aligned with requirements documented in the [module specifications][ModuleSpecifications] section.

Below, we provide some guidance on what modules you can / cannot propose.

- **Resource modules**: resource modules have bring extra value to the end user (can't just be simple wrappers) and **MUST** mapped 1:1 to RPs (resource providers) and top level resources. You **MUST** follow the module specifications and your modules **SHOULD** be [WAF aligned][WAFAligned].
  - Good examples:
    - Virtual machine: the VM module is highly complex and therefore, it brings extra value to the end user by providing a wide variety of features (e.g., diagnostics, RBAC, domain join, disk encryption, backup and more).
    - Storage account: even though, this module is mainly built around one RP, it brings extra value by providing easy access to its child resources, such as file/table/queue services, as well as additional standard interfaces (e.g., diagnostics, RBAC, encryption, firewall, etc.).
  - Bad examples:
    - NIC or Public IP (PIP) module: these would be simple wrappers around the NIC/PIP resource and wouldn't bring any extra value. NICs and PIPs **SHOULD** be surfaced as part of the VM module (or any other primary resources that require them).
    - Diagnostic settings: these are too low-level "sub resources", and highly dependent on their "primary resource's" RP defined as "interfaces" and therefore **MUST** be used as part of a resource module holding a primary resource - see [Diagnostic Settings][DiagnosticSettings] documentation about the correct implementation.

- **Pattern modules**: In case of pattern modules, ideally you should start from architectural patterns, published in the [Azure Architecture Center][AzureArchitectureCenter], and build your pattern module by leveraging resource modules that are required to implement the pattern. AVM does not provide architectural guidance on how you should design your pattern, but you **MUST** follow the module specifications and your modules **SHOULD** be [WAF aligned][WAFAligned].
  - Good examples:
    - Landing zone accelerators for N-tier web application; AKS cluster; SAP: there are numerous examples for these architectures in Azure Architecture Center that already have baked in guidance / smart defaults that are WAF Aligned, therefore these are good candidates for pattern modules. Modules owners should leverage resource modules to implement the pattern.
    - Hub and spoke topology: it's a common pattern that is used by many customers and there are great examples available through Azure Architecture Center, as well as [Azure Landing Zones][ALZ]. Also a good candidate for a pattern module.
  - Bad examples:
    - A pair of Virtual machines: being a simple wrapper, this solution wouldn't bring any extra value as it doesn't provide a complete solution.
    - Key Vault that deploys automatically generated secrets: this is aligned with the definition of a resource modules, therefore it should be categorized as such.

### Where do I need to go to make sure the module I'd like to propose is not already in the works?

The [AVM core team][AVMCoreTeam] maintains the list of [Bicep][BicepModules] and [Terraform][TFModules] modules and tracks the status of each module. Based on this module catalog, you can check if the module you'd like to build is already in the works (e.g., it's being worked on in a feature branch but hasn't been published yet).

{{< hint type=warning title=TBD icon=gdoc_gitea >}}
Module catalog is to be published soon.
{{< /hint >}}

### I need a new module but I cannot own/author it for various reasons, what should I do?

Each AVM module requires a [module owner][ModuleOwners] and **MAY** have additional [module contributors][ModuleContributors].

Essentially, you have 3 options:

1. You sign up to be a module owner (and optionally, you can find additional contributors to help you).
2. You find / request someone else to be the module owner (and optionally, you can be a contributor).
3. You propose a module and wait until the AVM core team finds a module owner for you (who then can optionally leverage the help of additional contributors).

As these options are increasingly more time consuming, we recommend you to start with considering option 1 and only if you cannot own the module, should you move to option 2 and then 3.

You can propose a new module [here][ModuleProposal].


### How long will it take for someone to respond and a module to be created/updated and published?

Whilst there are SLAs defined for providing [support][ModuleSupport] for existing modules, there are currently no SLAs in place for the creation of new modules. The AVM core team is a small team and is currently working on automating the module creation process to make it as easy as possible for module owners to create and publish modules on their own.

Beside of providing program level governance, the [AVM core team][AVMCoreTeam] is mainly responsible for defining the module specifications, providing tooling (such as test frameworks and pipelines), guidance and support to module owners, as well as facilitating the creation of new modules by maintaining the module catalog and identifying volunteers for owning the modules. However, modules will be created and maintained by a broader community of [module owners][ModuleOwners].

### How do I let the AVM team know I really need an AVM module to unblock me / my project / my company?

- If you're an external user, you can propose a module [here][ModuleProposal] and provide as much context as possible under the "Module Details" section (e.g., why do you need the module, what's the business impact of not having it, etc.).

- If you're a Microsoft employee and have already proposed a module [here][ModuleProposal], you can reach out to the AVM core team directly via [Teams][AVMChannel] to provide more details internally.

The AVM core team will then triage the request and get back to you with next steps. You can accelerate the process of creating the module by volunteering to be a [module owner][ModuleOwners].

### How will the central module catalog be updated?

The [AVM core team][AVMCoreTeam] will maintain the module catalog and update it as new modules are created and published or existing ones are updated or retired.



<br>

<!-- ## Preparing the environment for a new module

### Bicep & Terraform

#### What are the mandatory labels to be used while managing issues on GitHub?

SNFR23


#### How will the support SLAs be automatically enforced?

All issues created in a module repo will be automatically be picked up and tracked by the GitHub Policy Service. This service will take the necessary steps when escalation is needed as per the SLAs defined in the [Module Support][ModuleSupport] chapter .

{{< hint type=warning title=TBD icon=gdoc_gitea >}} More details to be added. {{< /hint >}}

#### How should the issue templates and customer tags/labels be used?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

#### Where can I test my module during development?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

#### Can I run manual tests or should I only use GH actions?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

<br>

### Bicep

#### What folder do I need to create the module in? Who checks if the naming convention was followed?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

#### Who will change CODEOWNERS file?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

<br>

### Terraform

#### How will the new repo be created? What will the repo be called? Who checks if the naming convention was followed?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

#### What are the mandatory .md files for the root of the repo (readme; security; support; etc.)

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

#### Do I need to use/create custom issue types/templates?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

<br>

## Developing the module

### To start developing the module, which exact documents do I have to hold myself to?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

<!-- (please don't just point me to the root of the docs page 😊) -->

<!-- ### Where are examples to follow / first sample modules to get inspiration from? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

<!-- ### What are the guardrails/quality gates I need to be aware of/leverage/be compliant with? -->

<!-- ( CI environment with the ai.e., where's theutomated tests that I need to use and comply with)? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

<!-- ### Will I get any level of code review from the AVM core team to make sure my work is up to the standards? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

<!-- 
module owners are supposed to start development locally, using their own subscriptions, and getting closer to publication, the AVM (central) test environment will have to be leveraged through pipelines/SPNs.

some recurring tests to ensure we can catch failures after things like API changes.

AVM sub for that. Manual is only for initial - when you first start developing a new module -->

<br>
<!-- 
## Publishing the module

<!-- ### What steps do I need to follow?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} --> 

<!-- 
- Is everything fully automated? 
- Do I need to talk to someone to publish my module in the registry or can I do it on my own? 
-->

<br>

<!-- ## Updating a module -->

<!-- ### What if I forget to bump up the version number? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

### How will it impact the publication flow? Will it mess up the telemetry reporting? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

<!-- to avoid the latter, we should probably consider using a moduleVersion param instead of a variable - or implement some tests that guarantee that this gets updated every time there's was an update to the module -->

<!-- ### I'm already using a module today, but its missing a feature, what should I do?

{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}}

<br>

## Security/Bugs in a module

### I have found a security issue with a module or the way it deploys its resources/pattern, what should I do? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

<!-- - Covered in SECURITY.md? -->

<br>
<!-- 
## Retiring a module
### What do I need to do to retire the module of and old solution?
{{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

<!-- 
A new Azure resource or resource provider got released that supersedes an existing module. Now that I've had the replacement module published for 2 years, what do I need to do to retire the old solution? 
we need to document a step that describes that the status flag of the modules needs to be changed to retired in the module index 
-->

<!-- ### Can modules be deleted from their respective repo (or can their repo be deleted)? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} -->

 <!-- 
 to this, we concluded earlier that the right approach is to leave one last readme.md file that provides context and points end users to the replacement solution. 
 -->
<!-- ### Will modules ever be deleted from their respective registries? -->

<!-- {{< hint type=warning title=TBD icon=gdoc_gitea >}} {{< /hint >}} --> 

 <!-- 
 on this, we concluded earlier that a module MUST never get deleted from a registry. It can be "abandoned" as part of the retirement flow.  
 -->

[AVMCoreTeam]: /Azure-Verified-Modules/specs/shared/team-definitions/#avm-core-team
[BicepModules]: /Azure-Verified-Modules/indexes/bicep/
[TFModules]: /Azure-Verified-Modules/indexes/terraform/
[ModuleOwners]: /Azure-Verified-Modules/specs/shared/team-definitions/#module-owners
[ModuleContributors]: /Azure-Verified-Modules/specs/shared/team-definitions/#module-contributors
[WAFAligned]: /Azure-Verified-Modules/faq/#what-does-avm-mean-by-waf-aligned
[ModuleProposal]: https://aka.ms/AVM/ModuleProposal
[ModuleSupport]: /Azure-Verified-Modules/help-support/module-support/
[AVMChannel]: https://aka.ms/AVM/channel
[ModuleSpecifications]: Azure-Verified-Modules/specs/
[DiagnosticSettings]: /Azure-Verified-Modules/specs/shared/interfaces/#diagnostic-settings
[AzureArchitectureCenter]: https://learn.microsoft.com/en-us/azure/architecture/browse/
[ALZ]: https://aka.ms/alz
