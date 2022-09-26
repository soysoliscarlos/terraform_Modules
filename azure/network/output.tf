output "rg-name" {
  value = azurerm_resource_group.main[*].name
}