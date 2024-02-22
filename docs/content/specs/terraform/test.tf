variable "security_group" {
  type = object({
    id = string
  })
  default = null
}
