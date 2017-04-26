# Configure Microsoft Azure Provider and assign variables
provider "azurerm" {
 subscription_id = "09e89473-a429-4097-b36d-31ff31a52579"
 client_id       = "386e0048-7153-4060-b061-ae5a15bcc632"
 client_secret   = "gJPXFIt7MslkJS6ec9X8yzAqqAbgHg8K5nXd4zJK8PM="
 tenant_id       = "414efc33-68fe-4520-802f-aea4401192d0"
}

# Create a resource group
resource "azurerm_resource_group" "rgmodule" {
  name     = "MyTestResourceGroup"
  location = "EastUS"
}
