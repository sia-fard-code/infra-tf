output "vpc_dc_private_subnets" {
  value = module.vpc_dc.private_subnets
}
output "vpc_dc_private_subnets_blue" {
  value = slice(module.vpc_dc.private_subnets, 0,2)
}
output "vpc_dc_private_subnets_green" {
  value = slice(module.vpc_dc.private_subnets, 2,4)
}

output "vpc_dc_public_subnets" {
  value = module.vpc_dc.public_subnets
}
output "vpc_dc_pan_subnets" {
  value = aws_subnet.pan.*.id
}

output "vpc_dc_id" {
  value = module.vpc_dc.vpc_id
}
output "vpc_prv_subnet_a" {
  value = module.vpc_dc.private_subnets[0]
}

output "vpc_prv_subnet_b" {
  value = module.vpc_dc.private_subnets[1]
}

output "vpc_db_prv_subnet_ids" {
  value = module.vpc_dc.database_subnets
}

output "vpc_db_prv_subnet_cidr_blocks" {
  value = module.vpc_dc.database_subnets_cidr_blocks
}
output "vpc_prv_subnet_cidr_blue" {
  value = slice(module.vpc_dc.private_subnets_cidr_blocks,0,2)
}
output "vpc_prv_subnet_cidr_green" {
  value = slice(module.vpc_dc.private_subnets_cidr_blocks,2,4)
}

output "vpc_dc_private_route_table_ids" {
  value = module.vpc_dc.private_route_table_ids
}

output "vpc_dc_db_route_table_ids" {
  value = module.vpc_dc.database_route_table_ids
//  value = aws_route_table.db_zone2.*.id
}

