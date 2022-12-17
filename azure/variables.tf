variable "environment" {
    type        = string
    default     = "dev"
}

variable "address_space" {
    type        = list(string)
    default = ["10.0.0.0/16"]
}

variable "client_secret" {}

variable resource {
  default = {
    prefix   = "tfdemo"
    location = "westus2"
    tag      = "demo"
  }
}

variable "default_subnet_address_prefix" {
    type = list(string)
    default = ["10.0.1.0/24"]
}

variable apiVm_subnet_address_prefix {
    default =  ["10.0.4.0/24"]
}


variable "public_subnet_address_prefix" {
    type = list(string)
    default = ["10.0.2.0/24"]
}

variable "bastion_subnet_address_prefix" {
    type = list(string)
    default = ["10.0.3.0/24"]
}

variable "name_postfix" {
    type        = string
}

variable "ssh_port" {
    type = number
    default = 22
}

variable "new_lb_ip_address" {
    type = string
    default = "10.0.2.10"
}