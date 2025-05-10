output "storage_connection_string" {
  description = "The connection string for the Azure Storage account"
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}
