
terraform {
#   backend "s3" {
    
#   }
}




module "compute_test" {
  
    source = "../modules/compute"
    CompartmentOCID = "ocid1.compartment.oc1..aaaaaaaahqtobojbuf76qn67k2o5zllyvjnz3ltclwm5l5jefdgjekqalnvq"
    TestServerShape = var.TestServerShape
    tenancy_ocid = var.tenancy_ocid
    private_id = var.private_id
    WebVMCount = var.WebVMCount
    ssh_public_key = var.ssh_public_key
    WebServerBootStrap = var.WebServerBootStrap
    bastion_host = "144.24.216.232"
    ssh_private_key = var.ssh_private_key
    servername = "test"    
}
