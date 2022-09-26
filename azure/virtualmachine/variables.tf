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
    subnet_id = string
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
    private_ip_address_allocation = "dynamic" # "dynamic" - "static"
    subnet_id = "default"
  }]
}