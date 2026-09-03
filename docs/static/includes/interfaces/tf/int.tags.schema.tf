variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "resource_tags" {
  type = object({
    resources = optional(object({
      this  = optional(map(string))
      child = optional(map(string))
    }))
    modules = optional(object({
      child = optional(object({
        resources = optional(object({
          this = optional(map(string))
        }))
      }))
    }))
  })
  default     = null
  description = "(Optional) Per-resource tag overrides."
}
