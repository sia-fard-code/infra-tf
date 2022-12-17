

#output "compartment_id" {
#    value = module.compartment.compartment_id
#}


output "vcn_id" {
    value = module.network.vcn_id
}


output "dhcp_options_id" {
    value = module.network.dhcp_options_id
}

output "intgw_id" {
    value = module.network.intgw_id
}


output "private_id" {
    value = module.network.private_id
}

output "routetableid" {
    value = module.network.routetableid
}

output "blue_lpg" {
    value = oci_core_local_peering_gateway.blue_lpg.id
}

output "green_lpg" {
    value = oci_core_local_peering_gateway.green_lpg.id
}

output "db_lb_ip" {
    value = module.lb-db.lb_ip
}

#output "vault_key_id" {
#    value = module.vault.key_id
#}



# output "pubroutetableid" {
#     value = module.network.pubroutetableid
# }

# output "bluelbsubnetid" {
#     value = module.network.bluelbsubnetid
# }

# output "greenlbsubnetid" {
#     value = module.network.greenlbsubnetid
# }

# output "commonsubnetids" {
#     value = module.network.commonsubnetids
# }

# output "commonsubnetid" {
#     value = module.network.commonsubnetid
# }

output "bastion_host_public_ip" {
    value = module.bastion.bastion_host
}

# output db_pool_info {
#   value = module.asg-db.instance_in_pool_info.private_ip
# }

# output "load_balancers_id" {
#   value = module.int-lb-api.load_balancers
# }