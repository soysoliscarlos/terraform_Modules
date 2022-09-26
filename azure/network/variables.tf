# Module networking 
variable "rg_config" {
  type = object({
    create_rg = bool
    name      = string
    location  = string
  })
  default = {
    create_rg = false
        name = "01"
    location = "eastus2"
  }
}

variable "vnet_config" {
  type = object({
    create_vnet = bool
    name = string
    address_space = list(string)
    })
    default = {
      create_vnet = true
      name = "01"
      address_space = ["192.168.0.0/24"]
    }
}

variable "subnets_config" {
  type = list(object({
    name = string
    address_prefixes = list(string)
  }))
  default = [ {
    name = "default"
    address_prefixes = ["192.168.0.0/24"]
  } ]
}

variable "resource_group_name" {
  type = string
  description = "Define Resource group name in case does not create a resource group"
  default = "01"
}

variable "resource_group_location" {
  type = string
  description = "Define location in case does not create a resource group"
  default = "eastus2"
}