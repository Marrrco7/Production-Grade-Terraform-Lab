locals {
  name_prefix = "tf-lab-${var.environment}"
}
resource "azurerm_key_vault" "main" {
  name                = "${local.name_prefix}-kv"
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = var.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false
}