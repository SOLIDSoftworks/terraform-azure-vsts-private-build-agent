resource "azurerm_managed_disk" "data_disk" {
  name                 = "${var.name}${count.index}_managed_disk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"

  count = "${var.count}"
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = "${var.name}${count.index}_virtual_machine"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${element(azurerm_network_interface.network_interface.*.id, count.index)}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}${count.index}_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {    
    name            = "${element(azurerm_managed_disk.data_disk.*.name, count.index)}"
    managed_disk_id = "${element(azurerm_managed_disk.data_disk.*.id, count.index)}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${element(azurerm_managed_disk.data_disk.*.disk_size_gb, count.index)}"
  }

  os_profile {
    computer_name  = "${var.name}${count.index}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  provisioner "file" {
    source = "${path.module}/provisioning/provision.sh"
    destination = "/home/${var.admin_username}/provision.sh"

    connection {
      type        = "ssh"
      host        = "${element(azurerm_public_ip.public_ip.*.ip_address, count.index)}"
      user        = "${var.admin_username}"
      password    = "${var.admin_password}"
    }
  }
    
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y install dos2unix",
      "sudo dos2unix /home/${var.admin_username}/provision.sh",
      "chmod +x /home/${var.admin_username}/provision.sh",
      "/home/${var.admin_username}/provision.sh ${var.vsts_agent_group} ${var.name}${count.index} ${var.vsts_user} ${var.vsts_personal_access_token}"
    ]

    connection {
      type        = "ssh"
      host        = "${element(azurerm_public_ip.public_ip.*.ip_address, count.index)}"
      user        = "${var.admin_username}"
      password    = "${var.admin_password}"
    }
  }

  count = "${var.count}"
}