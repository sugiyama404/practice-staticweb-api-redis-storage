variable "resource_group" {}
variable "subnet_pe_subnet_id" {}
variable "virtual_network_vnet_id" {}
variable "app_service_principal_id" {}
variable "redis_host" {}
variable "redis_port" {}
variable "storage_connection_string" {}

data "azurerm_client_config" "current" {}
locals {
  principal_id = data.azurerm_client_config.current.object_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
}
