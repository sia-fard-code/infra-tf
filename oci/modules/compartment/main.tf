data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_id
}
data "oci_identity_regions" "home-region" {
  filter {
    name   = "key"
    values = [data.oci_identity_tenancy.tenancy.home_region_key]
  }
}

provider "oci" {
  alias            = "home"
  tenancy_ocid     = var.tenancy_id
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = data.oci_identity_regions.home-region.regions[0]["name"]
}

resource "oci_identity_compartment" "compartment" {
    #Required
    provider       = oci.home
    compartment_id = var.CompartmentOCID
    description = var.compartment_description
    name = var.compartment_name
}
