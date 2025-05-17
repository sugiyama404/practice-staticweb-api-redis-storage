# Redis Cache Private Endpoint
resource "azurerm_private_endpoint" "redis_pe" {
  name                = "securedemo-redis-pe"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  subnet_id           = var.subnet_pe_subnet_id

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
