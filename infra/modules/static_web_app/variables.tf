variable "resource_group" {}
variable "subnet_app_subnet_id" {}
variable "app_service_url" {}
variable "static_web_app_name" {
  description = "Name of the static web app"
  type        = string
  default     = "securedemo-swa"
}
