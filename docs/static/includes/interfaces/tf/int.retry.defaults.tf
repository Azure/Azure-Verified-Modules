# Module-level defaults example: a hypothetical module retries
# on common transient replication errors and tunes the back-off interval. The
# overall variable default is `{}` (not `null`) so the per-field defaults take
# effect, and consumers can still override any individual field.
variable "retry" {
  type = object({
    error_message_regex  = optional(list(string), ["AnotherOperationInProgress", "TooManyRequests"])
    interval_seconds     = optional(number, 30)
    max_interval_seconds = optional(number, 300)
  })
  default     = {}
  description = <<DESCRIPTION
Retry configuration applied to every `azapi` resource managed by the module. This module ships defaults tuned for Storage Account replication; consumers **MAY** override any field.

- `error_message_regex`  - (Optional) A list of regex patterns matching error messages that trigger a retry.
- `interval_seconds`     - (Optional) Initial interval between retries in seconds.
- `max_interval_seconds` - (Optional) Maximum interval between retries in seconds.
DESCRIPTION
}
