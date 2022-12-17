
variable "environment" {
}

variable "color" {
    default = "blue"
}

variable "address_space_map" {
    default = {
        dev = "10.100.0.0/16"
        qa = "10.110.0.0/16"
        sandbox = "10.104.0.0/16"
        blue = "10.101.0.0/16"
    }
}

output "address_space_common" {
    value = lookup(var.address_space_map, var.environment)
}

output "address_space_color" {
    value = lookup(var.address_space_map, var.color)
}

output "address_space_sandbox" {
    value = lookup(var.address_space_map, "sandbox")
}

variable "subnets_map" {
    default = {
        dev = ["10.100.1.0/24", "10.100.2.0/24", "10.100.3.0/24", "10.100.4.0/24"]
        blue = ["10.101.1.0/24", "10.101.2.0/24", "10.101.3.0/24", "10.101.4.0/24"]
        sandbox = "10.104.2.0/24"
    }
}

output "subnets" {
    value = lookup(var.subnets_map, var.environment)
}

output "subnet_color" {
    value = lookup(var.subnets_map, var.color)
}

output "subnet_sandbox" {
    value = lookup(var.subnets_map, "sandbox")
}

output "rg" {
    value = {
        common = "common_rg"
        vnet = "vnet_common_rg"
        blue = "blue_rg"
    }
}