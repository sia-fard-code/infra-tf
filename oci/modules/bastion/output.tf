output "bastion_host" {
    value = oci_core_instance.Bastion[0].public_ip
}
