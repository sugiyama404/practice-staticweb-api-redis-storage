# Key Vault
resource "azurerm_key_vault" "kv" {
  name                          = "securedemo-kv"
  location                      = var.resource_group.location
  resource_group_name           = var.resource_group.name
  enabled_for_disk_encryption   = true
  tenant_id                     = local.tenant_id
  soft_delete_retention_days    = 7
  purge_protection_enabled      = false
  sku_name                      = "standard"
  enable_rbac_authorization     = true
  public_network_access_enabled = false

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}
