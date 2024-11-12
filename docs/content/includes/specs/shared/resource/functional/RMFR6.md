---
title: "RMFR6 - Parameter/Variable Naming"
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
tags: ["Class-Resource","Type-Functional","Category-Inputs","Language-Shared","Enforcement-MUST","Persona-Owner","Persona-Contributor","Lifecycle-Maintenance"]
type: "posts"
---

#### ID: RMFR6 - Category: Inputs - Parameter/Variable Naming

Parameters/variables that pertain to the primary resource **MUST NOT** use the resource type in the name.

e.g., use `sku`, vs. `virtualMachineSku`/`virtualmachine_sku`

Another example for where RPs contain some of their name within a property, leave the property unchanged. E.g. Key Vault has a property called `keySize`, it is fine to leave as this and not remove the `key` part from the property/parameter name.