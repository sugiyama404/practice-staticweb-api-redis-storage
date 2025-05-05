resource "azurerm_private_dns_zone_virtual_network_link" "redis_dns_link" {
  name                  = "redisdnslink"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.redis_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}
