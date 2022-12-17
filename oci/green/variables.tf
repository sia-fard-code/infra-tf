variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "ssh_public_key" {
}

variable "ssh_private_key" {
}

variable "color" {
  default = "green"
}
# variable "ssh_bas_private_key" {
#   default = "~/.oci/bastion.key"
# }

# variable "ssh_bas_public_key" {
#   default = "~/.oci/bastion.pub"
# }

variable "region" {
  default = "me-jeddah-1"
}

/* Availability domain can be 0, 1 or 2 - use the one that has free resources */
#variable "availability_domain" {
#  default = 1
#}

variable "TestServerShape" {
  default = "VM.Standard2.1"
}

variable "InstanceImageOCID" {
  type = map(string)

  # TASK: set machine image for your environment, get it e.g. using command:
  #     oci compute image list --compartment-id "your compartment OCID" |less
  # and search for image with name Linux-7.6-2019, like written below (with different date).
  # TIP: the variable map can be (re-)defined also in env-vars file.
  default = {
    // Oracle-Linux-7.6-2019.02.20-0
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaacss7qgb6vhojblgcklnmcbchhei6wgqisqmdciu3l4spmroipghq"
    uk-london-1  = "ocid1.image.oc1.uk-london-1.aaaaaaaarruepdlahln5fah4lvm7tsf4was3wdx75vfs6vljdke65imbqnhq"
    me-jeddah-1 = "ocid1.image.oc1.me-jeddah-1.aaaaaaaa4fijw22qksb2xyfmovnoxwp2asxke5ppcg37iqdc6tb43lui2ipa"
  }
}

####################################################################################################
variable "WebServerBootStrap" {
  default = "./userdata/webServer"
}

variable "BastionServerBootStrap" {
  default = "../userdata/bastionServer"
}

variable "WebVMCount" {
  default = 1
}

variable "BastionVMCount" {
  default = 1
}

####################################################################################################
variable "GREENVCNCIDR" {
}

variable "COMMONVCNCIDR" {
  
}
variable "PublicCIDR" {
}


variable "GREENPrivateSubnetCIDR" {
}

variable "GREENPublicSubnetCIDR" {
}



variable "CompartmentOCID" {
  default = "ocid1.compartment.oc1..aaaaaaaatkiufgkm4jl5xsbdqlyho6fd3n54mlau625y7w6i5qrgj5q7ocwq"
}

variable "backendset" {
  default =  "web-backend"
}

variable "lbname" {
  default = "web"
}

variable "zone_name_or_id" {
}

variable "bucket" {  
}

variable "certfile" {
}

variable "private_key" {
}

variable "public_certificate" {
}

variable "dns_zone_name" {
  
}


variable "web-domain" {
  
}

variable "api-domain" {
  
}


variable "bastion_ip" {
  
}

variable "mount_target_ip_address" {
  
}

variable "compartment_id" {

}

variable "access_key" {
  
}

variable "secret_key" {

}