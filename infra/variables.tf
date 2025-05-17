variable "app_name" {
  description = "application name"
  type        = string
  default     = "todoapp"
}

variable "location" {
  description = "location"
  type        = string
  default     = "eastasia"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "image_name" {
  description = "image name"
  type        = string
  default     = "todoapp"
}
