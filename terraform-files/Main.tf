provider "azurerm" {
   features {}
}


resource "azurerm_resource_group" "myterraformgroup" {
  name     = "${var.resourcegroup}"
  location = "${var.location}"
}

resource "azurerm_virtual_network" "mynetwork" {
  name                = "${var.vname}"
  address_space       = "${var.addressspace}"
  location            = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subname}"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
  virtual_network_name = "${azurerm_virtual_network.mynetwork.name}"
  address_prefixes     = "${var.addressprefix}"
}

resource "azurerm_network_security_group" "web_server_nsg"{
  name                 = "terraformdemo"
  location             = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
}

resource "azurerm_network_security_rule" "web_server_nsg_rule_rdp" {
  name                         = "RDP Inbound"
  priority                     = 100
  direction                    = "Inbound"
  access                       = "Allow"
  protocol                     = "Tcp"
  source_port_range            = "*"
  destination_port_range       = "22"
  source_address_prefix        = "*"
  destination_address_prefix   = "*"
  resource_group_name          = "${azurerm_resource_group.myterraformgroup.name}"
  network_security_group_name  = "${azurerm_network_security_group.web_server_nsg.name}"
}

resource "azurerm_public_ip" "name"{
  name                 = "${var.publicip}"
  location             = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name  = "${azurerm_resource_group.myterraformgroup.name}"
  allocation_method    = "Static"
}

resource "azurerm_network_interface" "demonic" {
  name                = "${var.machinename}"
  location            = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name = "${azurerm_resource_group.myterraformgroup.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.name.id}"
  }
}

resource "azurerm_virtual_machine" "azurevm" {
  name                  = "${var.vmname}"
  location              = "${azurerm_resource_group.myterraformgroup.location}"
  resource_group_name   = "${azurerm_resource_group.myterraformgroup.name}"
  network_interface_ids = ["${azurerm_network_interface.demonic.id}"]
  vm_size               = "${var.vmsize}"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "roshan"
    admin_password = "Roshan79"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

#   provisioner "file" {
#   source       = "/home/roshan/workspace/terraformDemos/Main.tf"
#   destination  = "/home/roshan/Main.tf"

#   connection {
#     type     = "ssh"
#     user     = "roshan"
#     password = "Roshan79"
#   }
# }
}

output name {
  value       = "${azurerm_resource_group.myterraformgroup.name}"
}

output time {
  value       = "${timestamp()}"
}

output vmIP {
  value       = "${azurerm_public_ip.name.*.id}"
}



