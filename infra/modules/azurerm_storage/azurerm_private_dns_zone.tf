# Private DNS Zone for Storage Blob
resource "azurerm_private_dns_zone" "blob_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group.name

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
