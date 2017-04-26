# Module specific Variables
variable "module_location" { description = "Azure region" }
variable "module_os_image" { description = "Azure Publisher,Offer,Sku,Version" }
variable "module_admin_username" { description = "" }
variable "module_admin_password" { description = "" }
variable "module_service_name" {description = "name of service"}
variable "module_pub_key" {description = ""}  
variable "module_subnet_id" { description = "" }
variable "module_storage_account_type" { description = "" }
variable "module_instance_type" { description = "" }
variable "module_instance_count" { description = "" }

resource "azurerm_resource_group" "module" {
  name     = "${var.module_service_name}"
  location = "${var.module_location}"
}

resource "azurerm_network_interface" "module" {
  name                = "${azurerm_resource_group.module.name}-${count.index + 1}"
  count               = "${var.module_instance_count}"
  resource_group_name = "${azurerm_resource_group.module.name}"
  location            = "${var.module_location}"

  ip_configuration {
    name                          = "democonfig${count.index + 1}"
    subnet_id                     = "${var.module_subnet_id}"
    private_ip_address_allocation = "dynamic"

    # public_ip_address_id = "${azurerm_public_ip.module.id}"
    public_ip_address_id = "${element(azurerm_public_ip.module.*.id, count.index)}"
  }
}

resource "azurerm_public_ip" "module" {
  name                         = "${azurerm_resource_group.module.name}-${count.index + 1}"
  count                        = "${var.module_instance_count}"
  location                     = "${var.module_location}"
  resource_group_name          = "${azurerm_resource_group.module.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_virtual_machine" "module" {
  name                             = "${azurerm_resource_group.module.name}-${count.index + 1}"
  count                            = "${var.module_instance_count}"
  location                         = "${var.module_location}"
  resource_group_name              = "${azurerm_resource_group.module.name}"
  network_interface_ids            = ["${element(azurerm_network_interface.module.*.id, count.index)}"]
  vm_size                          = "${var.module_instance_type}"
  delete_os_disk_on_termination    = true

  storage_image_reference {
    publisher = "${element(split(",",var.module_os_image),0)}"
    offer     = "${element(split(",",var.module_os_image),1)}"
    sku       = "${element(split(",",var.module_os_image),2)}"
    version   = "${element(split(",",var.module_os_image),3)}"
  }

  storage_os_disk {
    name              = "${azurerm_resource_group.module.name}${count.index + 1}-os"
    managed_disk_type = "${var.module_storage_account_type}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${azurerm_resource_group.module.name}-${count.index + 1}"
    admin_username = "${var.module_admin_username}"
    admin_password = "${var.module_admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.module_admin_username}/.ssh/authorized_keys"
      key_data = "${file(var.module_pub_key)}"
    }
  }
}

# resource "azurerm_storage_account" "module" {
#   name                = "25charlimitglobalunique"
#   resource_group_name = "${azurerm_resource_group.module.name}"
#   location            = "${var.module_location}"
#   account_type        = "${var.module_storage_account_type}"
# }

output "private_ips" {
  value = ["${azurerm_network_interface.module.*.private_ip_address}"]
}

output "public_ips" {
  value = ["${azurerm_public_ip.module.*.ip_address}"]
}