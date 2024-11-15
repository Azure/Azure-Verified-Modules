---
title: TFNFR17 - Variables with Descriptions
url: /spec/TFNFR17
geekdocNav: true
geekdocAlign: left
geekdocAnchor: true
type: posts
tags: [
  Class-Resource,
  Class-Pattern,
  Type-NonFunctional,
  Category-CodeStyle,
  Language-Terraform,
  Severity-SHOULD,
  Persona-Owner,
  Persona-Contributor,
  Lifecycle-BAU
]
priority: 21170
---

#### ID: TFNFR17 - Category: Code Style - Variables with Descriptions

The target audience of `description` is the module users.

For a newly created `variable` (Eg. `variable` for switching `dynamic` block on-off), it's `description` **SHOULD** precisely describe the input parameter's purpose and the expected data type. `description` **SHOULD NOT** contain any information for module developers, this kind of information can only exist in code comments.

For `object` type `variable`, `description` can be composed in HEREDOC format:

```terraform
variable "kubernetes_cluster_key_management_service" {
  type = object({
    key_vault_key_id         = string
    key_vault_network_access = optional(string)
  })
  default     = null
  description = <<-EOT
  - `key_vault_key_id` - (Required) Identifier of Azure Key Vault key. See [key identifier format](https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates#vault-name-and-object-name) for more details. When Azure Key Vault key management service is enabled, this field is required and must be a valid key identifier. When `enabled` is `false`, leave the field empty.
  - `key_vault_network_access` - (Optional) Network access of the key vault Network access of key vault. The possible values are `Public` and `Private`. `Public` means the key vault allows public access from all networks. `Private` means the key vault disables public access and enables private link. Defaults to `Public`.
EOT
}
```
