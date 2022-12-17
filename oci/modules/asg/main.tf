
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



resource "oci_autoscaling_auto_scaling_configuration" "ServerASG" {
  # count = length(var.lb_ids)
    auto_scaling_resources {

        id = oci_core_instance_pool.InstancePool.id
        type = "instancePool"
    }
    compartment_id = var.CompartmentOCID
    policies {
        display_name = "ServerASGpolicy"
        capacity {
            initial = "1"
            max = "2"
            min = "1"
        }
        policy_type = "threshold"
        rules {
            action {
                type = "CHANGE_COUNT_BY"
                value = "1"
            }
            display_name = "${terraform.workspace}-${var.color}-${var.appname}-ServerASGrule"
            metric {
                metric_type = "CPU_UTILIZATION"
                threshold {
                    operator = "GT"
                    value = "80"
                }
            }
        }
        rules {
            action {
                type  = "CHANGE_COUNT_BY"
                value = "-1"
            }
            display_name = "${var.appname}ServerASGrulein"
            metric {
                metric_type = "CPU_UTILIZATION"
                threshold {
                    operator = "LT"
                    value = "20"
                }
            }
        }
    }
    cool_down_in_seconds = "300"
    display_name = "${terraform.workspace}-${var.color}-${var.appname}-asg"
}

resource "oci_core_instance_configuration" "ServerConfiguration" {
    compartment_id = var.CompartmentOCID
    display_name = "${terraform.workspace}-${var.color}-${var.appname}-ic"
    # instance_id = var.instance_id
    # source = "INSTANCE"
     instance_details {
      instance_type = "compute"

      launch_details {
        compartment_id = var.CompartmentOCID

        display_name = "test"
        metadata = {
        }

        shape = var.TestServerShape
        source_details {
          source_type = "image"
          image_id    = data.oci_core_images.ubuntu-18-04.images.0.id
        }
    }
  }

}


resource "oci_core_instance_pool" "InstancePool" {
    # for_each = toset([var.lb_ids])
    compartment_id = var.CompartmentOCID
    instance_configuration_id = oci_core_instance_configuration.ServerConfiguration.id  
    placement_configurations {
        availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[0]["name"]

        primary_subnet_id = var.primary_subnet_id
        

    }
    size = "1"
    display_name = "${terraform.workspace}-${var.color}-${var.appname}-ip"
    
    dynamic "load_balancers" {
    for_each = var.lbs
      content {
        backend_set_name = load_balancers.value["backend_set_name"]
        load_balancer_id = load_balancers.value["load_balancer_id"]
        port = load_balancers.value["port"]
        vnic_selection = "PrimaryVnic"
      }
    }

    lifecycle {
      ignore_changes = [instance_configuration_id, size]
    }
}



data "oci_core_instance_pool_instances" "TFInstancePoolInstanceDatasources" {
  # count = length(var.lb_ids)
  compartment_id   = var.CompartmentOCID
  instance_pool_id = "${oci_core_instance_pool.InstancePool.id}"
}

data "oci_core_instance" "instance_in_pool" {
  # count = length(var.lb_ids)
  instance_id = "${data.oci_core_instance_pool_instances.TFInstancePoolInstanceDatasources.instances.0.id}"
}