variable "CompartmentOCID" {

}

variable "tenancy_ocid" {
  
}

variable "appname" {
  
}
variable "vcn_id" {
  
}

variable "lbname" {
}

variable "color" {
}


variable "WebVMCount" {
}

variable "routetableid" {

}

variable "dhcp_options_id" {

}

# variable "instance_id" {

# }

variable "primary_subnet_id" {
    type = string
    description = "(optional) describe your variable"
}


variable "subnet_id" {
  
}

variable "ssh_public_key" {

}

variable "TestServerShape" {
  
}



# variable "ip_address" {

# }



# variable "lb_id" {
  
# }

# variable "backendset_name" {

# }

# variable "backend_port" {
  
# }

variable "lbs" {
    # type = list(object({
    #     backend_set_name           = string
    #     lb_id                   = string
    #     backend_port                  = number
    # }))
}

variable "is_load_balancer_required" {
}