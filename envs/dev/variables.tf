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