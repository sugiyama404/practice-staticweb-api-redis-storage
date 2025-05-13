variable "resource_group" {}
variable "subnet_app_subnet_id" {}
variable "image_name" {}
variable "registry_login_server" {}
variable "registry_admin_username" {}
variable "registry_admin_password" {}
variable "key_vault_name" {}

variable "app_service_plan_sku_tier" {
  description = "The SKU tier of the App Service Plan"
  type        = string
  default     = "Standard"
}

