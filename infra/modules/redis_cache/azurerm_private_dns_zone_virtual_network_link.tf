resource "azurerm_private_dns_zone_virtual_network_link" "redis_dns_link" {
  name                  = "redisdnslink"
  resource_group_name   = var.resource_group.name
  private_dns_zone_name = azurerm_private_dns_zone.redis_dns.name
  virtual_network_id    = var.virtual_network_vnet_id
}
