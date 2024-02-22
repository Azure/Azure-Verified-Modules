# Having default empty map and `nullable = false` means that
# any expressions within the module are simpler.
variable "tags" {
  type     = map(string)
  default  = {}
  nullable = false
  description = "A mapping of tags which should be assigned to the resource."
}
