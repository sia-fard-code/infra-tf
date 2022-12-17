

output "instance_ip" {
    value = oci_core_instance.Server[0].private_ip
}


output "instance_id" {
    value = oci_core_instance.Server[0].id
}


# output "api_instance_ip" {
#     value = oci_core_instance.APIServer[0].private_ip
# }


# output "api_instance_id" {
#     value = oci_core_instance.APIServer[0].id
# }

# output "db_instance_ip" {
#     value = oci_core_instance.DbServer[0].private_ip
# }


# output "db_instance_id" {
#     value = oci_core_instance.DbServer[0].id
# }