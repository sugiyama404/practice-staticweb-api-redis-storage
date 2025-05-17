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
  subscription_id = var.subscription_id
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

# Storage Account
module "storage" {
  source                  = "./modules/azurerm_storage"
  resource_group          = azurerm_resource_group.resource_group
  subnet_pe_subnet_id     = module.network.subnet_pe_subnet_id
  subnet_app_subnet_id    = module.network.subnet_app_subnet_id
  virtual_network_vnet_id = module.network.virtual_network_vnet_id
}

# Network
module "network" {
  source         = "./modules/network"
  resource_group = azurerm_resource_group.resource_group
}

# container_registry
module "container_registry" {
  source         = "./modules/container_registory"
  resource_group = azurerm_resource_group.resource_group
}

# bash
module "bash" {
  source                = "./modules/bash"
  image_name            = var.image_name
  registry_name         = module.container_registry.registry_name
  registry_login_server = module.container_registry.registry_login_server
}

# redis_cache
module "redis_cache" {
  source                  = "./modules/redis_cache"
  resource_group          = azurerm_resource_group.resource_group
  subnet_pe_subnet_id     = module.network.subnet_pe_subnet_id
  virtual_network_vnet_id = module.network.virtual_network_vnet_id
}

# static_web_app
module "static_web_app" {
  source               = "./modules/static_web_app"
  resource_group       = azurerm_resource_group.resource_group
  subnet_app_subnet_id = module.network.subnet_app_subnet_id
  app_service_url      = module.app_service.app_service_url
  app_service_id       = module.app_service.app_service_id
}

# app_service
module "app_service" {
  source                    = "./modules/app_service"
  resource_group            = azurerm_resource_group.resource_group
  subnet_app_subnet_id      = module.network.subnet_app_subnet_id
  image_name                = var.image_name
  registry_login_server     = module.container_registry.registry_login_server
  registry_admin_username   = module.container_registry.registry_admin_username
  registry_admin_password   = module.container_registry.registry_admin_password
  redis_host                = module.redis_cache.redis_host
  redis_port                = module.redis_cache.redis_port
  storage_connection_string = module.storage.storage_connection_string
  redis_primary_key         = module.redis_cache.redis_primary_key
  storage_container_name    = module.storage.storage_container_name
}
