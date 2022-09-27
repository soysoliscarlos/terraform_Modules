output "vms" {
  value = azurerm_windows_virtual_machine.main
  sensitive = true
}
output "networkinterfaces" {
    value = azurerm_network_interface.main
}
output "managed_disks" {
    value = azurerm_managed_disk.main
}