# Private DNS Zone for Redis
resource "azurerm_private_dns_zone" "redis_dns" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
