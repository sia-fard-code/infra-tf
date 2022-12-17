
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.CompartmentOCID
}

data "oci_core_images" "ubuntu-18-04" {
  compartment_id = var.CompartmentOCID
  operating_system = "Canonical Ubuntu"
  filter {
    name = "display_name"
    values = ["^Canonical-Ubuntu-18.04-([\\.0-9-]+)$"]
    regex = true
  }
}

output "ubuntu-18-04-latest-name" {
  value = data.oci_core_images.ubuntu-18-04.images.0.id
}

resource "oci_core_route_table" "PublicRoutingTable" {
  compartment_id = var.CompartmentOCID
  vcn_id         = var.vcn_id
  display_name   = "Public Routing Table-${terraform.workspace}"

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = var.intgw_id
  }
}

# Bastion SecList - Public Internet
resource "oci_core_security_list" "BastionSubnetSeclist" {
  compartment_id = var.CompartmentOCID
  display_name   = "Bastion Subnet Seclist-${terraform.workspace}"
  vcn_id         = var.vcn_id

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    # ssh
    tcp_options {
      max = 22
      min = 22
    }

    protocol = "6"
    source   = "0.0.0.0/0"
  }
}

# resource "oci_core_subnet" "BastionSubnet" {
#   count               = min(var.BastionVMCount, 2)
#   availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index]["name"]
#   cidr_block          = var.BastionSubnetCIDRs[count.index]
#   display_name        = "${terraform.workspace}-${var.color}-BASTION"
#   dns_label           = "bastion${count.index}"
#   compartment_id      = var.CompartmentOCID
#   vcn_id              = var.vcn_id
#   route_table_id      = oci_core_route_table.PublicRoutingTable.id
#   security_list_ids   = [oci_core_security_list.BastionSubnetSeclist.id]
#   dhcp_options_id     = var.dhcp_options_id
# }


// Bastion
// running in Public subnet
// accessible with ssh
resource "oci_core_instance" "Bastion" {
  count               = min(var.BastionVMCount,2)
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index % 2]["name"]
  compartment_id      = var.CompartmentOCID
  display_name        = "${terraform.workspace}-bastion"
  hostname_label      = "bastion${count.index}"

  create_vnic_details {
    assign_public_ip = false
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu-18-04.images.0.id
  }

  shape     = var.TestServerShape
  subnet_id = var.subnet_id

  metadata = {
    ssh_authorized_keys = file(var.bastion_ssh_public_key)
    user_data           = base64encode(file(var.BastionServerBootStrap))
  }
}


data "oci_core_private_ips" "pubiptestIps" {
  ip_address = oci_core_instance.Bastion[0].private_ip
  subnet_id  = var.subnet_id
}

resource "oci_core_public_ip" "pubip1" {
  compartment_id = var.CompartmentOCID
  display_name   = "reserved public ip"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.pubiptestIps.private_ips[0]["id"]
}