# Shared Variables
variable "tenant_id" { 
  description = "The tenant id that has been assigned in Azure"
}

variable "client_id" {
  description = "The client id of the app that has been given permissions to access the subscription"
}

variable "client_secret" {
  description = "The client secret of the app that has been given permissions to access the subscription"
}

variable "subscription_id" {
  description = "The ID of the Azure subscription"
  default     = ""
}

variable "location" {
  default     = "eastus"
}

# networking-stuff
variable "vnet_address_space" {
  default  = "10.10.0.0/23"
}

variable "demosubnet" {
  default = "10.10.0.0/24"
}

variable "gateway_subnet" {
  default = "10.10.1.248/29"
}

# service-vm
variable "service_name" {
  default = "MyDemoService"
}

variable "subnet_id" {
  default = ""
}

variable "os_image" {
  default = "OpenLogic,CentOS,7.3,latest"
}

variable "admin_username" {
  default = "demouser"
}

variable "admin_password" {
  default = ""
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}