---
title: Bicep Interfaces
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/bicep/interfaces/
---

{{< hint type=warning >}}

**Legacy content**

The content on this website has been deprecated and will be removed in the future.

Please refer to the new documentation under the [Bicep Interfaces](/Azure-Verified-Modules/specs/bcp/res/interfaces/) chapter for the most up-to-date information.

{{< /hint >}}

This page details the Bicep-specific interfaces/schemas for AVM Resource Modules features/extension resources.

{{< toc >}}

<br>

## Secrets export

Secrets used inside a module can be exported to a Key Vault reference provided as per the below schema.
This implementation provides a secure way around the current limitation of Bicep on providing a secure template output (that can be used for secrets).

The user must
- provide the resource Id to a Key Vault. The principal used for the deployment must be allowed to set secrets in this Key Vault.
- provide a name for each secret they want to store (opt-in). The module will suggest which secrets are available via the implemented user-defined type.

The module returns an output table where the key is the name of the secret the user provided, and the value contains both the secret's resource Id and URI.

{{< hint type=important >}}

The feature must be implemented as per the below schema. Diversions are only allowed in places marked as `>text<` to ensure a consistent user experience across modules.

{{< /hint >}}

{{< tabs "diag-settings" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/bicep/int.secExp.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/bicep/int.secExp.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "[modules/keyVaultExport.bicep] file" >}}
  {{< include file="/static/includes/interfaces/bicep/int.secExp.module.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Output Usage Example" >}}
  When using a module that implements the above interface, you can access its outputs for example in the following ways:
  {{< include file="/static/includes/interfaces/bicep/int.secExp.output.bicep" language="bicep" options="linenos=false" >}}
  Which returns a JSON-formatted output like
  {{< include file="/static/includes/interfaces/int.secExp.output.jsonFmt.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

<br>
