resource "oci_core_route_table" "PrivateRoutingTable" {
  compartment_id = var.CompartmentOCID
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "privrt-${terraform.workspace}"

  dynamic "route_rules" {
    for_each = var.prv_route_rules
    content {
      destination = route_rules.value["cidr_dest"]
      network_entity_id = route_rules.value["lpg_id"]
    }
  }
}


resource "oci_core_route_table" "PublicRoutingTable" {
  compartment_id = var.CompartmentOCID
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "pubrt-${terraform.workspace}"
  
  dynamic "route_rules" {
    for_each = var.pub_route_rules
    content {
      destination = route_rules.value["cidr_dest"]
      network_entity_id = route_rules.value["lpg_id"]
    }
  }
}


# Private SecList - Private Network
resource "oci_core_security_list" "PrivateSubnetSeclist" {
  compartment_id = var.CompartmentOCID
  display_name   = "privseclist-${terraform.workspace}"
  vcn_id         = oci_core_virtual_network.VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "all"
    source   = var.VCNCIDR
  }

  ingress_security_rules {
    # ssh
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.VCNCIDR
  }

  ingress_security_rules {
    # ssh
    tcp_options {
      max = 22
      min = 22
    }
    protocol = "6"
    source   = var.PublicCIDR
  }

  ingress_security_rules {
    # http
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = var.PublicCIDR
  }
  ingress_security_rules {
    # https
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = var.PublicCIDR
  }
    ingress_security_rules {
    # https
    tcp_options {
      max = 8443
      min = 8443
    }
    protocol = "6"
    source   = var.PublicCIDR
  }

  ingress_security_rules {
    # https
    tcp_options {
      max = 27017
      min = 27017
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  
  ingress_security_rules {
    # https
    tcp_options {
      max = 111
      min = 111
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  
  ingress_security_rules {
    # https
    tcp_options {
      max = 2048
      min = 2048
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    # https
    tcp_options {
      max = 2049
      min = 2049
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    # https
    udp_options {
      max = 111
      min = 111
    }
    protocol = "17"
    source   = "0.0.0.0/0"
  }
  
  ingress_security_rules {
    # https
    udp_options {
      max = 2048
      min = 2048
    }
    protocol = "17"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    # https
    udp_options {
      max = 2049
      min = 2049
    }
    protocol = "17"
    source   = "0.0.0.0/0"
  }

  ingress_security_rules {
    # https
    tcp_options {
      max = 9092
      min = 9092
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
ingress_security_rules {
    # https
    tcp_options {
      max = 23
      min = 23
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }



}
resource "oci_core_security_list" "LBSubnetSeclist" {
  compartment_id = var.CompartmentOCID
  display_name   = "Loadbalancer Subnet Seclist-${terraform.workspace}-${var.color}"
  vcn_id         = oci_core_virtual_network.VCN.id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    # http
    tcp_options {
      max = 80
      min = 80
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
  ingress_security_rules {
    # https
    tcp_options {
      max = 443
      min = 443
    }
    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

# resource "oci_core_subnet" "LBSubnet" {
#   cidr_block        = var.LBSubnetCIDR
#   display_name      = "${terraform.workspace}-${var.color}-lbsubnet"
#   dns_label         = "public"
#   compartment_id    = var.CompartmentOCID
#   vcn_id            = oci_core_virtual_network.VCN.id
#   route_table_id    = oci_core_route_table.PublicRoutingTable.id
#   security_list_ids = [oci_core_security_list.LBSubnetSeclist.id]
#   dhcp_options_id   = oci_core_virtual_network.VCN.default_dhcp_options_id
# }

resource "oci_core_subnet" "PrivateSubnet" {
  cidr_block                 = var.PrivateSubnetCIDR
  display_name               = "${terraform.workspace}-${var.color}-priv"
  dns_label                  = "private"
  compartment_id             = var.CompartmentOCID
  vcn_id                     = oci_core_virtual_network.VCN.id
  route_table_id             = oci_core_route_table.PrivateRoutingTable.id
  security_list_ids          = [oci_core_security_list.PrivateSubnetSeclist.id]
  dhcp_options_id            = oci_core_virtual_network.VCN.default_dhcp_options_id
  prohibit_public_ip_on_vnic = "true"
}

resource "oci_core_subnet" "PublicSubnet" {
  cidr_block                 = var.PublicSubnetCIDR
  display_name               = "${terraform.workspace}-${var.color}-pub"
  dns_label                  = "public"
  compartment_id             = var.CompartmentOCID
  vcn_id                     = oci_core_virtual_network.VCN.id
  route_table_id             = oci_core_route_table.PublicRoutingTable.id
  security_list_ids          = [oci_core_security_list.PrivateSubnetSeclist.id]
  dhcp_options_id            = oci_core_virtual_network.VCN.default_dhcp_options_id
}


# resource "oci_core_subnet" "COMMONSubnet" {
#   cidr_block                 = var.COMMONSubnetCIDR
#   display_name               = "${terraform.workspace}-common-priv"
#   dns_label                  = "common"
#   compartment_id             = var.CompartmentOCID
#   vcn_id                     = oci_core_virtual_network.VCN.id
#   route_table_id             = oci_core_route_table.PrivateRoutingTable.id
#   security_list_ids          = [oci_core_security_list.PrivateSubnetSeclist.id]
#   dhcp_options_id            = oci_core_virtual_network.VCN.default_dhcp_options_id
#   prohibit_public_ip_on_vnic = "true"
# }

resource "oci_core_virtual_network" "VCN" {
  cidr_block     = var.VCNCIDR
  compartment_id = var.CompartmentOCID
  display_name   = "${terraform.workspace}-${var.color}-vcn"
  dns_label      = "masimo"
}

resource "oci_core_internet_gateway" "InetGW" {
  compartment_id = var.CompartmentOCID
  display_name   = "ig-${terraform.workspace}-${var.color}"
  vcn_id         = oci_core_virtual_network.VCN.id
}

resource "oci_core_nat_gateway" "NATGateway" {
  compartment_id = var.CompartmentOCID
  vcn_id         = oci_core_virtual_network.VCN.id
  display_name   = "natgw-${terraform.workspace}-${var.color}"
}

