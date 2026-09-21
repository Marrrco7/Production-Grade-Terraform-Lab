variable "location" {
  type        = string
  description = "Azure region"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to deploy into"
}

variable "subnets" {
  type = map(object({
    address_prefix = string
  }))
  description = "Map of subnets to create"
  default = {
    app = {
      address_prefix = "10.0.1.0/24"
    }
  }
}