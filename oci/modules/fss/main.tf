
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.CompartmentOCID
}



resource "oci_file_storage_file_system" "fss" {
  compartment_id = var.CompartmentOCID
  count               = var.fss_count
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index]["name"]
  display_name        = "msn"
}

resource "oci_file_storage_mount_target" "fss_mt" {
	depends_on          = ["oci_file_storage_file_system.fss"]
  count               = 1
  compartment_id      = var.CompartmentOCID
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index]["name"]
	subnet_id           = var.subnet_id
  ip_address = var.mount_target_ip_address
	display_name        = "${terraform.workspace}-fss-mt"
}

resource "oci_file_storage_export_set" "export_set" {
  # Required
  mount_target_id = oci_file_storage_mount_target.fss_mt[0].id

  # Optional
  display_name      = "${terraform.workspace}-fss-es"
}

resource "oci_file_storage_export" "my_export_fs_1" {
  #Required
  export_set_id  = oci_file_storage_export_set.export_set.id
  file_system_id = oci_file_storage_file_system.fss[0].id
  path           = var.export_path_fs_1
}

resource "oci_file_storage_export" "my_export_fs_2" {
  #Required
  export_set_id  = oci_file_storage_export_set.export_set.id
  file_system_id = oci_file_storage_file_system.fss[0].id
  path           = var.export_path_fs_2
}