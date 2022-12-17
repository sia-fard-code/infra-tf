module "vpc_dc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = true

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs              = local.azs
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  create_elasticache_subnet_route_table = true

  default_vpc_enable_dns_hostnames = true
  default_vpc_enable_dns_support   = true
  enable_dns_hostnames             = true
  enable_dns_support               = true

  create_database_nat_gateway_route      = false
  create_database_subnet_route_table     = false
  create_database_subnet_group           = true
  create_database_internet_gateway_route = false

  enable_nat_gateway = contains(var.pan_env, terraform.workspace) ? false : true
  enable_vpn_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = true

  public_subnet_tags = {
    "Name"                                        = "${var.env}-MSN-Public"
    "Public 2A CIDR"                              = local.public_subnets[0]
    "Public 2B CIDR"                              = local.public_subnets[1]
  }

  private_subnet_tags = {
    "Name"                                        = "${var.env}-MSN-Private"
    "Private 2A CIDR"                             = local.private_subnets[0]
    "Private 2B CIDR"                             = local.private_subnets[1]
  }

  database_subnet_tags = {
    "Name"       = "${var.env}-MSN-Private-DB"
    "DB 2A CIDR" = local.database_subnets[0]
    "DB 2B CIDR" = local.database_subnets[1]
  }
  instance_tenancy = "default"

  map_public_ip_on_launch         = true
  assign_ipv6_address_on_creation = false

  vpc_tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "pan" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  availability_zone = local.azs[count.index]
  vpc_id     = module.vpc_dc.vpc_id
  cidr_block = local.pan_subnets[count.index]

  tags = {
    Name = "${var.env}-MSN-PAN-${local.azs[count.index]}"
  }
}

resource "aws_eip" "nat" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  vpc      = true
}

resource "aws_nat_gateway" "pan" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = module.vpc_dc.public_subnets[count.index]

  tags = {
    Name = "${var.env}-MSN-PAN-${local.azs[count.index]}"
  }
}

resource "aws_route_table" "pan" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  vpc_id     = module.vpc_dc.vpc_id
  tags = {
    Name = "${var.env}-MSN-PAN-${local.azs[count.index]}"
  }

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = [propagating_vgws]
  }
}

resource "aws_route" "pan_nat_gateway" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  route_table_id         = element(aws_route_table.pan.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.pan.*.id, count.index)
}

resource "aws_route_table_association" "pan" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  route_table_id         = element(aws_route_table.pan.*.id, count.index)
  subnet_id              = element(aws_subnet.pan.*.id, count.index)
}
/*
resource "aws_route_table" "db_zone2" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  vpc_id     = module.vpc_dc.vpc_id
  tags = {
    Name = "MasimoSafetyNet-${local.azs[count.index]}-DB"
  }

  lifecycle {
    # When attaching VPN gateways it is common to define aws_vpn_gateway_route_propagation
    # resources that manipulate the attributes of the routing table (typically for the private subnets)
    ignore_changes = [propagating_vgws]
  }
}

resource "aws_route_table_association" "db_zone2" {
  count      = contains(var.pan_env, terraform.workspace)? length(local.azs) : 0
  subnet_id      = module.vpc_dc.database_subnets[count.index]
  route_table_id = aws_route_table.db_zone2[count.index].id
}

*/
