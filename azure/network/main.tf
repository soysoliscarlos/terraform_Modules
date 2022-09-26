# Module networking 
resource "azurerm_resource_group" "main" {
  count    = var.rg_config.create_rg ? 1 : 0
  name     = var.rg_config.name
  location = var.rg_config.location
}

locals {
  rglocation = try(
    "${azurerm_resource_group.rg[0].location}",
    "${var.resource_group_location}"
  )
  rgname = try(
    "${azurerm_resource_group.rg[0].name}",
    "${var.resource_group_name}"
  )
}

resource "azurerm_virtual_network" "main" {
  count    = var.vnet_config.create_vnet ? 1 : 0
  name                = "VNet_${var.vnet_config.name}"
  address_space       = "${var.vnet_config.address_space}"
  location            = "${local.rglocation}"
  resource_group_name = "${local.rgname}"
  depends_on = [
    azurerm_resource_group.main,
  ]
}

resource "azurerm_subnet" "subnet" {
  for_each = { for each in var.subnets_config : each.name => each }
  name                                           = "${each.value.name}"
  address_prefixes                               = "${each.value.address_prefixes}"
  #enforce_private_link_endpoint_network_policies = true
  resource_group_name                            = azurerm_virtual_network.vnet[0].resource_group_name
  virtual_network_name                           = azurerm_virtual_network.vnet[0].name

  depends_on = [
    azurerm_virtual_network.main,
  ]
}