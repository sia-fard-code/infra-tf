


output instance_in_pool_info {
  value = "${data.oci_core_instance.instance_in_pool}"
}

# output "instance_id" {
#   value = data.oci_core_instance.instance_in_pool.id
# }

# output instance_in_pool_info {
#   value = data.oci_core_instance.instance_in_pool
# }

# output "subnet_cidr" {
#     value = oci_core_subnet.LBSubnet.cidr_block
# }