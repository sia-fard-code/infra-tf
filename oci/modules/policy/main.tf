resource "oci_identity_policy" "Streaming-user-policy" {
  name           = "Streaming-user-policy"
  description    = "policy created by terraform"
  compartment_id = var.CompartmentOCID

  statements = ["Allow group Administrators to use vnics in compartment ${var.compartment_name}",
    "Allow group Administrators to use subnets in compartment ${var.compartment_name}",
    "Allow group Administrators to use network-security-groups in compartment ${var.compartment_name}",
    "Allow group Administrators to manage streams in compartment ${var.compartment_name}",
    "Allow group Administrators to manage stream-push in compartment ${var.compartment_name}",
    "Allow group Administrators to manage stream-pull in compartment ${var.compartment_name}",
    "Allow group Administrators to manage stream-family in compartment ${var.compartment_name}",
  ]
}