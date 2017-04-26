module "networking-stuff" {
  source                = "./Modules/networking-stuff"
  location              = "${var.location}"
  vnet_address_space    = "${var.vnet_address_space}"
  demosubnet            = "${var.demosubnet}"
  gateway_subnet        = "${var.gateway_subnet}"
}