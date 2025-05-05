variable "name_prefix" {
  description = "Prefix for the name of the resources"
  type        = string
  default     = "example"
}

variable "location" {
  description = "The Azure location to deploy the resources"
  type        = string
  default     = "East US"
}

variable "virtual_network_cidr" {
  description = "The CIDR prefix for the virtual network. This should be at least a /22. Example 10.0.0.0/22"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
