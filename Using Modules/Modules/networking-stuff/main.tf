# Module specific Variables
variable "location" {
  description = "Azure region"
}

variable "vnet_address_space" {
  description = "The VNET assigned network prefix in cidr notation."
}

variable "gateway_subnet" {
  description = "Gateway Subnet for the VNET in cidr notiation."
}

variable "demosubnet" {
  description = "The Subnet1 within the vnet_address_space in cidr notation."
}

resource "azurerm_resource_group" "module" {
  name     = "Demo-Network-Infrastructure"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "module" {
  name                = "DemoVirtualNetwork"
  resource_group_name = "${azurerm_resource_group.module.name}"
  address_space       = ["${var.vnet_address_space}"]
  location            = "${var.location}"

  lifecycle {
    ignore_changes = ["dns_servers"] #ignore when dns servers have been set
  }
}

resource "azurerm_subnet" "subnet1" {
  name                 = "DemoSubnet"
  resource_group_name  = "${azurerm_resource_group.module.name}"
  virtual_network_name = "${azurerm_virtual_network.module.name}"
  address_prefix       = "${var.demosubnet}"
}

resource "azurerm_subnet" "gateway" {
  #name "GatewaySubnet" is an Azure reserved name. Do NOT edit name.
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.module.name}"
  virtual_network_name = "${azurerm_virtual_network.module.name}"
  address_prefix       = "${var.gateway_subnet}"
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