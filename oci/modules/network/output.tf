
output "vcn_id" {
    value = oci_core_virtual_network.VCN.id
}


output "dhcp_options_id" {
    value = oci_core_virtual_network.VCN.default_dhcp_options_id
}

output "intgw_id" {
    value = oci_core_internet_gateway.InetGW.id
}

output "natgw_id" {
    value = oci_core_nat_gateway.NATGateway.id
}

output "private_id" {
    value = oci_core_subnet.PrivateSubnet.id
}

output "routetableid" {
    value = oci_core_route_table.PrivateRoutingTable.id
}


output "pubroutetableid" {
    value = oci_core_route_table.PublicRoutingTable.id
}

# output "lbsubnetid" {
#     value = oci_core_subnet.LBSubnet.*.id
# }

output "privsubnetid" {
    value = oci_core_subnet.PrivateSubnet.*.id
}

output "privsubnetids" {
    value = oci_core_subnet.PrivateSubnet.id
}


output "pubsubnetid" {
    value = oci_core_subnet.PublicSubnet.id
}

output "pubsubnetids" {
    value = oci_core_subnet.PublicSubnet.*.id
}


# output "commonsubnetid" {
#     value = oci_core_subnet.COMMONSubnet.id
# }


# output "commonsubnetids" {
#     value = oci_core_subnet.COMMONSubnet.*.id
# }
