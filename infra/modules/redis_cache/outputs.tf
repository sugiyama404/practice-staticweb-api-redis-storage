output "redis_url" {
  description = "The URL of the Redis Cache instance"
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
}

output "redis_hostname" {
  description = "The hostname of the Redis Cache instance"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_port" {
  description = "The port of the Redis Cache instance"
  value       = azurerm_redis_cache.redis.ssl_port
}
