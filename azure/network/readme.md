
## load the module

### Create a network with Resource Group
```
module "network" {
  source = "./Modules/Networking"
  rg_config = var.rg_config
  vnet_config = var.vnet_config
  subnets_config = var.subnets_config
}
```
### Create a network without Resource Group
module "network" {
  source = "./Modules/Networking"
  vnet_config = var.vnet_config
  subnets_config = var.subnets_config
  resource_group_name = var.resource_group_name
  resource_group_location = var.resource_group_location
}


## Variables
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

# if not create a resource group have to add this variable
variable "rgname" {
  type = string
  description = "Define Resource group name in case does not create a resource group"
  default = "01"
}

variable "rglocation" {
  type = string
  description = "Define location in case does not create a resource group"
  default = "eastus2"
}