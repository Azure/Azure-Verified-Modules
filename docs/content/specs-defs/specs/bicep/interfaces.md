---
title: Interfaces
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
url: /specs/bicep/interfaces/
---

Below are the interfaces/schemas for AVM Resource Modules features/extension resources only relevant to Bicep.

{{< toc >}}

<br>

## Secrets export

Secrets used inside a module can be exported to a Key Vault reference provided as per the below schema.
It's implementation provides a secure way around Bicep's current limitation to be unable to securely output secrets.

The user must
- provide the resource Id to a Key Vault the deploying principal must be allowed to set secrets in
- provide a name for each secret they want to set (opt-in). The module will suggest which secrets are available via the implemented user-defined type

In return, the module has an output that returns a table where the key is the secret name the user provided, and the value both the secrets resource Id & uri.

{{< hint type=important >}}

The feature must be implemented as per the below schema and only divert in places marked via `>text<` to ensure a consistent user experience across modules.

{{< /hint >}}

{{< tabs "diag-settings" >}}
  {{< tab "Bicep User Defined Type, Parameter & Resource Example" >}}
  {{< include file="/static/includes/interfaces/int.secExp.udt.schema.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Bicep Input Example with Values" >}}
  {{< include file="/static/includes/interfaces/int.secExp.input.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "[modules/keyVaultExport.bicep] file" >}}
  {{< include file="/static/includes/interfaces/int.secExp.module.bicep" language="bicep" options="linenos=false" >}}
  {{< /tab >}}
  {{< tab "Output Usage Example" >}}
  When using a module that implements the above interface, you can access its outputs for example in the following ways:
  {{< include file="/static/includes/interfaces/int.secExp.output.bicep" language="bicep" options="linenos=false" >}}
  Which returns an JSON-formatted output like
  {{< include file="/static/includes/interfaces/int.secExp.output.jsonFmt.json" language="json" options="linenos=false" >}}
  {{< /tab >}}
{{< /tabs >}}

<br>
