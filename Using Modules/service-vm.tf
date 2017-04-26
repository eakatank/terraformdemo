module "service-vm" {
  source          = "./Modules/service-vm"
  module_location        = "${var.location}"
  module_os_image        = "${var.os_image}"
  module_admin_username  = "${var.admin_username}"
  module_admin_password  = "${var.admin_password}"
  module_service_name    = "${var.service_name}"
  module_pub_key         = "${var.pub_key}"
  module_subnet_id       = "${module.networking-stuff.subnet_id}"
  
  # Overrides
  module_storage_account_type  = "Standard_LRS"
  module_instance_type         = "Standard_F2"
  module_instance_count        = 2
}