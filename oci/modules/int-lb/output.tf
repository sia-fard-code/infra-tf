
output "load_balancers_id" {
    value = oci_load_balancer_load_balancer.lb.id
}

# output "load_balancers" {
#   description = "returns a list of object"
#   value       = data.oci_load_balancer_load_balancers.this.load_balancers
# }