locals {
  vm_name = var.vm_name
}
resource "azurerm_network_interface" "windows_vm_nic" {
  name = "${local.vm_name}-nic"
  location = var.location
  resource_group_name = var.resource_group_name
  enable_accelerated_networking = var.enable_acclerated_networking
  ip_configuration {
    name = "ipconfig1"
    subnet_id = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "win_vm" {
  name = "${local.vm_name}"
  resource_group_name = var.resource_group_name
  location = var.location
  size = var.vm_size
  admin_username = "suresh"#data.azurerm_key_vault_secret.username.value
  admin_password = "Lakshmi94u@0523"#data.azurerm_key_vault_secret.password.value
  encryption_at_host_enabled = var.encryption_at_host_enabled

  tags = var.tags
  
  source_image_reference {
    publisher = element(split(",", lookup(var.standard_os, var.vm_os_simple, "")), 0) #var.vm_os_publisher
    offer     = element(split(",", lookup(var.standard_os, var.vm_os_simple, "")), 1) #var.vm_os_offer
    sku       = element(split(",", lookup(var.standard_os, var.vm_os_simple, "")), 2) #var.vm_os_sku
    version   = var.vm_os_version 
  } 
     
  network_interface_ids = [
    azurerm_network_interface.windows_vm_nic.id,
  ]

  os_disk {
    caching = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
  }

     boot_diagnostics {
    storage_account_uri = "https://terraformsuresh0002.blob.core.windows.net"
  }


}