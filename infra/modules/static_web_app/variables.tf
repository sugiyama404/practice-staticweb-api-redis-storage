variable "resource_group" {
  description = "The resource group where the static web app will be deployed"
  type = object({
    id       = string
    location = string
    name     = string
  })
}

variable "static_web_app_name" {
  description = "Name of the static web app"
  type        = string
  default     = "securedemo-swa"
}

variable "subnet_app_subnet_id" {
  description = "The subnet ID for App Service integration"
  type        = string
}
