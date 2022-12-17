
output "lb_ip" {
    value = oci_load_balancer_load_balancer.lb.ip_address_details[0].ip_address
}

output "load_balancer_id" {
    value = oci_load_balancer_load_balancer.lb.id
}


output "backend_set_name" {
  value = oci_load_balancer_backend_set.lb-backendset[0].name
}