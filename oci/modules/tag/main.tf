resource "oci_identity_tag_namespace" "masimotags" {
    compartment_id = var.CompartmentOCID
    description = "${terraform.workspace}-${var.color}-tag"
    name = var.tag_namespace_name
    is_retired = false
}