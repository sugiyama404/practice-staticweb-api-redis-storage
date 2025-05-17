# ストレージアカウント
resource "azurerm_storage_account" "storage" {
  name                            = "notifystorage${random_string.storage_account_name.result}"
  location                        = var.resource_group.location
  resource_group_name             = var.resource_group.name
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = true

  network_rules {
    default_action             = "Deny" # セキュリティ向上のためにDenyに変更
    bypass                     = ["AzureServices"]
    ip_rules                   = []                         # 必要に応じて特定のIPを許可
    virtual_network_subnet_ids = [var.subnet_app_subnet_id] # App Serviceが使用するサブネットを許可
  }

  tags = {
    environment = "dev"
    purpose     = "secure-webapp"
  }
}

resource "random_string" "storage_account_name" {
  length  = 5
  special = false
  upper   = false
}
