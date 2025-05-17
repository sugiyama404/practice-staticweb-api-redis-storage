# Private DNS Zone for Redis
resource "azurerm_private_dns_zone" "redis_dns" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group.name

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
