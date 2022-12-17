
variable "bucket" {
  default = "com.masimo.msn.tf.non-prod"

}

variable "tenancy_ocid" {
}
variable "TestServerShape" {
  default = "VM.Standard2.1"
}

variable "InstanceImageOCID" {
  type = map(string)

  default = {
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaacss7qgb6vhojblgcklnmcbchhei6wgqisqmdciu3l4spmroipghq"
    uk-london-1  = "ocid1.image.oc1.uk-london-1.aaaaaaaarruepdlahln5fah4lvm7tsf4was3wdx75vfs6vljdke65imbqnhq"
    me-jeddah-1 = "ocid1.image.oc1.me-jeddah-1.aaaaaaaa4fijw22qksb2xyfmovnoxwp2asxke5ppcg37iqdc6tb43lui2ipa"
  }
}

variable "ssh_private_key" {
}

variable "ssh_public_key" {
}

variable "WebServerBootStrap" {
  default = "./userdata/webServer"
}

variable "WebVMCount" {
  default = 1
}

variable "private_id" {
    default = "ocid1.subnet.oc1.me-jeddah-1.aaaaaaaawqelsvijz54fvtc7yhnwqaz4r2nsizyi3jg6u6lyyyzjntmyrdiq"
  
}