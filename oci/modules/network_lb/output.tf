
output "lb_ip" {
    value = oci_network_load_balancer_network_load_balancer.network_load_balancer.ip_addresses[0].ip_address
}

output "load_balancer_id" {
    value = oci_network_load_balancer_network_load_balancer.network_load_balancer.id
}

