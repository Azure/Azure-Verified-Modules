variable "lock" {
  type = object({
    name = string
    type = optional(string, "CanNotDelete")
  })
  default = {}

  validation {
    condition     = contains(["CanNotDelete", "ReadOnly"], var.lock.type)
    error_message = "Lock type must be one of: CanNotDelete, ReadOnly."
  }
}
