# Module specific Variables
variable "location" { description = "Azure region" }
variable "service_name" {description = "name of service"}
variable "os_image" { description = "Azure Publisher,Offer,Sku,Version" }
variable "admin_username" { description = "" }
variable "admin_password" { description = "" }
variable "pub_key" {description = ""}  
variable "storage_account_type" { description = "" }
variable "instance_type" { description = "" }
variable "instance_count" { description = "" }
variable "subnet_id" { description = "" }

resource "azurerm_resource_group" "module" {
  name     = "${var.service_name}"
  location = "${var.location}"
}

resource "azurerm_network_interface" "module" {
  name                = "${azurerm_resource_group.module.name}-${count.index + 1}"
  count               = "${var.instance_count}"
  resource_group_name = "${azurerm_resource_group.module.name}"
  location            = "${var.location}"

  ip_configuration {
    name                          = "democonfig${count.index + 1}"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"

    # public_ip_address_id = "${azurerm_public_ip.module.id}"
    public_ip_address_id = "${element(azurerm_public_ip.module.*.id, count.index)}"
  }
}

resource "azurerm_public_ip" "module" {
  name                         = "${azurerm_resource_group.module.name}-${count.index + 1}"
  count                        = "${var.instance_count}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.module.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_virtual_machine" "module" {
  name                             = "${azurerm_resource_group.module.name}-${count.index + 1}"
  count                            = "${var.instance_count}"
  location                         = "${var.location}"
  resource_group_name              = "${azurerm_resource_group.module.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.module.*.id, count.index)}"]
  vm_size                          = "${var.instance_type}"
  delete_os_disk_on_termination    = true

  storage_image_reference {
    publisher = "${element(split(",",var.os_image),0)}"
    offer     = "${element(split(",",var.os_image),1)}"
    sku       = "${element(split(",",var.os_image),2)}"
    version   = "${element(split(",",var.os_image),3)}"
  }

  storage_os_disk {
    name              = "${azurerm_resource_group.module.name}${count.index + 1}-os"
    managed_disk_type = "${var.storage_account_type}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${azurerm_resource_group.module.name}-${count.index + 1}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${file(var.pub_key)}"
    }
  }
}

# resource "azurerm_storage_account" "module" {
#   name                = "25charlimitglobalunique"
#   resource_group_name = "${azurerm_resource_group.module.name}"
#   location            = "${var.location}"
#   account_type        = "${var.storage_account_type}"
# }

output "private_ips" {
  value = ["${azurerm_network_interface.module.*.private_ip_address}"]
}

output "public_ips" {
  value = ["${azurerm_public_ip.module.*.ip_address}"]
}