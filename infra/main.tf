terraform {
  required_version = "=1.10.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=4.20"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = var.subscription_id
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

resource "azurerm_resource_group" "resource_group" {
  name     = "${var.app_name}-resource-group"
  location = var.location
}

# Resource Providers
module "resource_providers" {
  source = "./modules/resource_providers"

  providers_to_register = [
    "Microsoft.Communication",
    "Microsoft.Storage",
    "Microsoft.Web",
  ]
}

# Storage Account
module "storage" {
  source         = "./modules/azurerm_storage"
  resource_group = azurerm_resource_group.resource_group
  depends_on     = [module.resource_providers]
}

# log_analytics
module "log_analytics" {
  source         = "./modules/log_analytics"
  resource_group = azurerm_resource_group.resource_group
  depends_on     = [module.resource_providers]
}
