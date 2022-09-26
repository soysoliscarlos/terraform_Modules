output "rg-name" {
  value = azurerm_resource_group.main[0].name
}
output "rg-location" {
  value = azurerm_resource_group.main[0].location
}
output "vnet-name" {
  value = azurerm_virtual_network.main[0].name
}
output "subnets" {
  value = azurerm_subnet.main
}