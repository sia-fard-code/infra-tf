
# Gets a list of Availability Domains
data "oci_identity_availability_domains" "ADs" {
  compartment_id = var.CompartmentOCID
}

data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.tenancy_ocid
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
  value = data.oci_core_images.ubuntu-18-04.images.0.display_name
}

data "oci_core_images" "webimg" {
  compartment_id = var.CompartmentOCID
  operating_system = "Canonical Ubuntu"
  filter {
    name = "display_name"
    values = ["^MSN-web"]
    regex = true
  }
}

data "oci_core_images" "APIimg" {
  compartment_id = var.CompartmentOCID
  operating_system = "Canonical Ubuntu"
  filter {
    name = "display_name"
    values = ["^MSN-api"]
    regex = true
  }
}

data "oci_core_images" "Mongoimg" {
  compartment_id = var.CompartmentOCID
  operating_system = "Canonical Ubuntu"
  filter {
    name = "display_name"
    values = ["^Mongo"]
    regex = true
  }
}

resource "oci_core_instance" "Server" {
  count               = var.WebVMCount
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[count.index % 3]["name"]
  

  ## If there are more instances than fault domains, terraform does automatic modulo
  #fault_domain        = lookup(data.oci_identity_fault_domains.FDs.fault_domains[count.index],"name")
  compartment_id = var.CompartmentOCID
  display_name   = "${var.servername}${count.index}-${terraform.workspace}"

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu-18-04.images.0.id
  }

  shape     = var.TestServerShape
  create_vnic_details {
    hostname_label = "${var.servername}${count.index}"
    subnet_id = var.private_id
    assign_public_ip = false
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key)
  }

  #  provisioner "remote-exec" {
  #   inline = [
  #     "sudo iptables -F",
  #   ]
  #   connection {
  #     bastion_host        = var.bastion_host
  #     bastion_user        = "ubuntu"
  #     bastion_private_key = file(var.ssh_private_key)
  #     type                = "ssh"
  #     host                = self.private_ip
  #     user                = "ubuntu"
  #     private_key         = file(var.ssh_private_key)
  #   }
  # }

}


