module "service-vm" {
  source          = "./Modules/service-vm"
  location        = "${var.location}"
  os_image        = "${var.os_image}"
  admin_username  = "${var.admin_username}"
  admin_password  = "${var.admin_password}"
  pub_key         = "${var.pub_key}"
  service_name    = "${var.service_name}"
  subnet_id       = "${module.networking-stuff.subnet_id}"
  
  # Overrides
  storage_account_type  = "Standard_LRS"
  instance_type         = "Standard_F2"
  instance_count        = 2
}