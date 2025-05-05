resource "azurerm_private_dns_zone_virtual_network_link" "kv_dns_link" {
  name                  = "kvdnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.kv_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
