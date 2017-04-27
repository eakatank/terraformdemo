# Module specific Variables
variable "module_location" {
  description = "Azure region"
}

variable "module_vnet_address_space" {
  description = "The VNET assigned network prefix in cidr notation."
}

variable "module_demosubnet" {
  description = "The Subnet1 within the vnet_address_space in cidr notation."
}

variable "module_gateway_subnet" {
  description = "Gateway Subnet for the VNET in cidr notiation."
}

resource "azurerm_resource_group" "module" {
  name     = "Demo-Network-Infrastructure"
  location = "${var.module_location}"
}

resource "azurerm_virtual_network" "module" {
  name                = "DemoVirtualNetwork"
  resource_group_name = "${azurerm_resource_group.module.name}"
  address_space       = ["${var.module_vnet_address_space}"]
  location            = "${var.module_location}"

  lifecycle {
    ignore_changes = ["dns_servers"] #ignore when dns servers have been set
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "DemoSubnet"
  resource_group_name  = "${azurerm_resource_group.module.name}"
  virtual_network_name = "${azurerm_virtual_network.module.name}"
  address_prefix       = "${var.module_demosubnet}"
}

resource "azurerm_subnet" "gateway" {
  #name "GatewaySubnet" is an Azure reserved name. Do NOT edit name.
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.module.name}"
  virtual_network_name = "${azurerm_virtual_network.module.name}"
  address_prefix       = "${var.module_gateway_subnet}"
}

output "vnet_rg_name" {
  value = "${azurerm_resource_group.module.name}"
}

output "vnet_name" {
  value = "${azurerm_virtual_network.module.name}"
}

output "subnet_id" {
  value = "${azurerm_subnet.subnet1.id}"
}
