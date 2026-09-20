terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "tfstatemarco"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    use_oidc             = true
  }
}

provider "azurerm" {
  features {}
  subscription_id = "d5efde2d-2884-4244-8e96-53367321279e"
  use_oidc        = true
}

resource "azurerm_resource_group" "lab" {
  name     = "terraform-lab-${var.environment}-rg"
  location = var.location
}

module "networking" {
  source              = "../../modules/networking"
  location            = var.location
  environment         = var.environment
  resource_group_name = azurerm_resource_group.lab.name
}

module "keyvault" {
  source              = "../../modules/keyvault"
  location            = var.location
  environment         = var.environment
  resource_group_name = azurerm_resource_group.lab.name
  tenant_id           = var.tenant_id
}