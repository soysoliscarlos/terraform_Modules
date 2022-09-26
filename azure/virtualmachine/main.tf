
resource "azurerm_windows_virtual_machine" "main" {
  for_each = { for each in var.vms_config : each.name => each }
  admin_password        = "${var.admin_password}"
  admin_username        = "${var.admin_username}"
  location              = azurerm_network_interface.main["${each.value.name}"].location
  name                  = "VM-${each.value.name}"
  network_interface_ids = [azurerm_network_interface.main["${each.value.name}"].id]
  resource_group_name   = azurerm_network_interface.main["${each.value.name}"].resource_group_name
  size                  = "${each.value.vmsize}"
  zone                  = "${each.value.zone}"
  boot_diagnostics {
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "${each.value.os_storage_account_type }"
    disk_size_gb         = "${each.value.os_disk_size_gb}"
    name                  = "Disk_os_${each.value.name}"
  }
  source_image_reference {
    offer     = "${each.value.os_offer}"
    publisher = "${each.value.os_publisher}"
    sku       = "${each.value.os_sku}"
    version   = "${each.value.os_version}"
  }
  depends_on = [
    azurerm_network_interface.main
  ]
}

resource "azurerm_network_interface" "main" {
  for_each = { for each in var.vms_config : each.name => each }
  enable_accelerated_networking = true
  location                      = each.value.location
  name                          = "NetInt_${each.value.name}"
  resource_group_name           = each.value.resource_group_name 
  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "${each.value.private_ip_address_allocation}"
    #private_ip_address            = "${var.SAPSLMvm.private_ip_address}"
    #public_ip_address_id          = 
    subnet_id                     = "azurerm_subnet.${each.value.subnet_id}.id"     ####### Edit this
  }
  depends_on = [
    azurerm_network_interface.SAPSLM
  ]
}