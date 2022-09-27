locals {
  key_managed_disks = { for x in toset(tolist(flatten([
    for each in var.vms_config : [
      for m in each.managed_disks: {
        name = each.name, 
        zone = each.zone, 
        lun  = m.lun,
        caching = m.caching,
        create_option = m.create_option, 
        diskname = "${each.name}-${m.lun}",
        storage_account_type = m.storage_account_type,
        disk_size_gb = m.disk_size_gb 
      }
    ]
  ]))) : 
  x.diskname => x}
}

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
    name                  = "Disk_os_VM-${each.value.name}"
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
  name                          = "NetInt_${each.value.name}"
  enable_accelerated_networking = "${each.value.enable_accelerated_networking}"
  location                      = "${var.vm_location}"
  
  resource_group_name           = "${var.vm_resource_group_name}"
  ip_configuration {
    name                          = "ipconfig_${each.value.name}"
    private_ip_address_allocation = "${each.value.private_ip_address_allocation}"
    #private_ip_address            = "${var.SAPSLMvm.private_ip_address}"
    #public_ip_address_id          = 
    subnet_id                     = "${var.subnet_id}"     ####### Edit this
  }
}

resource "azurerm_managed_disk" "main" {
  for_each = local.key_managed_disks
    name = "Disk_${each.key}"
    location             = azurerm_network_interface.main["${each.value.name}"].location
    resource_group_name   = azurerm_network_interface.main["${each.value.name}"].resource_group_name
    zone                 = "${each.value.zone}"
    create_option        = "${each.value.create_option}"
    storage_account_type = "${each.value.storage_account_type}"
    disk_size_gb         = "${each.value.disk_size_gb}"
}


resource "azurerm_virtual_machine_data_disk_attachment" "main" {
  for_each                = local.key_managed_disks
    managed_disk_id       = azurerm_managed_disk.main["${each.key}"].id
    virtual_machine_id    = azurerm_windows_virtual_machine.main["${each.value.name}"].id
    lun                   = "${each.value.lun}"
    caching               = "${each.value.caching}"
    depends_on = [
    azurerm_windows_virtual_machine.main
    ]
}