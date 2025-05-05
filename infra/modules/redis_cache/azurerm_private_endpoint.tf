# Redis Cache Private Endpoint
resource "azurerm_private_endpoint" "redis_pe" {
  name                = "securedemo-redis-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id

  private_service_connection {
    name                           = "redis-privateserviceconnection"
    private_connection_resource_id = azurerm_redis_cache.redis.id
    is_manual_connection           = false
    subresource_names              = ["redisCache"]
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
