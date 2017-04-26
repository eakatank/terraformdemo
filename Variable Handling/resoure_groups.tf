# Create a resource group
resource "azurerm_resource_group" "rgmodule" {
  count    = "${var.rg_count}"
  name     = "${var.rg_name}-${count.index + 1}"
  location = "EastUS"
}