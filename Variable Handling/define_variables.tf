# Parameterize the configurations.

# Let's first extract our access key, secret key, and region into a few variables. Create another file variables.tf with the following contents.

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
}

variable "location" {
  default = "EastUS"
}

variable "rg_name" {
  default = "Demo-Resource-Group"
}

variable "rg_count" {
  default = 1
}
