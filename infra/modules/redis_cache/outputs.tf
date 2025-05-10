output "redis_host" {
  description = "The hostname of the Azure Redis Cache instance"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_port" {
  description = "The port on which the Azure Redis Cache instance is listening"
  value       = azurerm_redis_cache.redis.ssl_port
}
