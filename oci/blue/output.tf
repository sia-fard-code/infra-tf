

output web_pool_info {
  value = module.asg-web.instance_in_pool_info.private_ip
}


output api_pool_info {
  value = module.asg-api.instance_in_pool_info.private_ip
}


# output pool_info {
#   value = module.asg-web.instance_in_pool_info
# }

# output instance_id {
#   value = module.asg-web.instance_id
# }