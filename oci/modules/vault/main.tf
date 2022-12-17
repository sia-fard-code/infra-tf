resource "oci_kms_vault" "msn_vault" {
    #Required
    compartment_id = var.compartment_id
    display_name = "${terraform.workspace}-msn-vault"
    vault_type = "DEFAULT"

}

resource "oci_kms_key" "msn_key" {
    #Required
    compartment_id = var.compartment_id
    display_name = "${terraform.workspace}-msn-cmk"
    protection_mode = "SOFTWARE"
    key_shape {
        #Required
        algorithm = "AES"
        length = 16

    }
    management_endpoint = oci_kms_vault.msn_vault.management_endpoint

}