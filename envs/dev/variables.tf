variable "location" {
  type        = string
  description = "Azure region for all resources"
  default     = "northeurope"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD tenant ID"
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

variable "nsg_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  description = "List of NSG security rules"
  default     = []
}