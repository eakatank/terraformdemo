# Configure Microsoft Azure Provider and assign variables
provider "azurerm" {
  subscription_id = ""
  client_id       = ""
  client_secret   = ""
  tenant_id       = ""
}

# Create a resource group
resource "azurerm_resource_group" "rgmodule" {
  name     = "Demo-Basic-Resource-Group"
  location = "EastUS"
}
