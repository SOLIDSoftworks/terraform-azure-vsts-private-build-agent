resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.name}_virtual_network"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.name}_subnet"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "public_ip" {
  name                         = "${var.name}_public_ip"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.resource_group.name}"
  public_ip_address_allocation = "static"
}

resource "azurerm_network_interface" "network_interface" {
  name                = "${var.name}_network_interface"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  ip_configuration {
    name                          = "${var.name}_network_interface_ip_configuration"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public_ip.id}"
  }
}
