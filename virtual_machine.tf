resource "azurerm_managed_disk" "data_disk" {
  name                 = "${var.name}_managed_disk"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"
}

resource "azurerm_virtual_machine" "virtual_machine" {
  name                  = "${var.name}_virtual_machine"
  location              = "${var.location}"
  resource_group_name   = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids = ["${azurerm_network_interface.network_interface.id}"]
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.name}_os_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.data_disk.name}"
    managed_disk_id = "${azurerm_managed_disk.data_disk.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.data_disk.disk_size_gb}"
  }

  os_profile {
    computer_name  = "${var.name}"
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
      host        = "${azurerm_public_ip.public_ip.ip_address}"
      user        = "${var.admin_username}"
      password    = "${var.admin_password}"
    }
  }

  provisioner "file" {
    source = "${path.module}/provisioning/getagent.sh"
    destination = "/home/${var.admin_username}/getagent.sh"

    connection {
      type        = "ssh"
      host        = "${azurerm_public_ip.public_ip.ip_address}"
      user        = "${var.admin_username}"
      password    = "${var.admin_password}"
    }
  }
}

resource "null_resource" "provision_build_agent" {
  triggers {
    virtual_machine_id = "${azurerm_virtual_machine.virtual_machine.id}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get -y install dos2unix",
      "sudo dos2unix /home/${var.admin_username}/provision.sh",
      "sudo dos2unix /home/${var.admin_username}/getagent.sh",
      "chmod +x /home/${var.admin_username}/provision.sh",
      "chmod +x /home/${var.admin_username}/getagent.sh",
      "/home/${var.admin_username}/provision.sh",    
      "/home/${var.admin_username}/getagent.sh",    

      "/home/${var.admin_username}/config.sh --acceptteeeula --pool ${var.vsts_agent_group} --agent ${var.name} --url https://${var.vsts_user}.visualstudio.com/ --work _work --auth PAT --token ${var.vsts_personal_access_token} --runasservice --replace",
      "sudo /home/${var.admin_username}/svc.sh install",
      "sudo /home/${var.admin_username}/svc.sh start"
    ]

    connection {
      type        = "ssh"
      host        = "${azurerm_public_ip.public_ip.ip_address}"
      user        = "${var.admin_username}"
      password    = "${var.admin_password}"
    }
  }
}