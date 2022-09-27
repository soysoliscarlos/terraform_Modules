
## Create vm
```
module "vms" {
  source = "github.com/soysoliscarlos/terraform_modules/azure/virtualmachine"
  vms_config = var.vms_config
  vm_resource_group_name = module.network01.rg-name
  vm_location = module.network01.rg-location
  subnet_id = module.network01.subnets["default"].id
}
```
## Variables
```
variable "admin_username" {
  type = string
  default = "azureadmin"
}

variable "admin_password" {
  type = string
  default = "azureadmin123."
}

variable "vms_config" {
  type = list(object({
    name = string
    vmsize = string
    zone = number
    os_storage_account_type = string
    os_disk_size_gb = number
    os_offer = string
    os_publisher = string
    os_sku = string
    os_version = string
    private_ip_address_allocation = string
    enable_accelerated_networking = bool
    managed_disks = list(object({
      lun = number
      create_option = string
      storage_account_type = string
      disk_size_gb         = number
      caching              = string
      }
    ))
  })) 
  default = [{
    name = "vm01"
    vmsize = "Standard_D2s_v5"
    zone = 1
    os_storage_account_type = "Standard_LRS" # Standard_LRS - StandardSSD_LRS - Premium_LRS
    os_disk_size_gb = 64 
    os_offer = "WindowsServer"
    os_publisher = "MicrosoftWindowsServer"
    os_sku = "2019-datacenter-smalldisk-g2"
    os_version = "latest"
    private_ip_address_allocation = "Dynamic" # "Dynamic" - "Static"
    enable_accelerated_networking = true
    managed_disks = [{
      lun = "0"
      create_option = "Empty"
      storage_account_type ="Standard_LRS"
      disk_size_gb         = 32
      caching              = "ReadOnly"
    }]
  }]
}
variable "vm_resource_group_name" {
  type = string
  default = "RG_01"
}
variable "vm_location" {
  type = string
  default = "eastus2"
}
variable "subnet_id" { 
  type = string
  default = ""
}
```

## outputs

* vms (List by name) 
* networkinterfaces (List by name) 
* managed_disks (List by name) 