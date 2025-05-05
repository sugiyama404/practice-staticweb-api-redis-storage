output "subnet_app_subnet_id" {
  value = azurerm_subnet.app_subnet.id
}

output "subnet_pe_subnet_id" {
  value = azurerm_subnet.pe_subnet.id
}

output "virtual_network_vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
