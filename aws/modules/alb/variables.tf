variable "env" {
  default = "dev"
}
variable "type" {
  default = "BLUE"
}


variable "vpc_id" {
}

variable "vpc_prv_subnet_cidr_blocks" {
}
variable "alb_web_sg_ids" {
}

variable "nlb_db_sg_ids" {
}
variable "alb_api_sg_ids" {
}
variable "alb_admin_sg_ids" {
}
variable "web_subnets" {
}
variable "api_subnets" {
}

variable "admin_subnets" {
}
variable "db_subnets" {
}
variable "domain" {
  default = ""
}
variable "msn_open_env" {
  default = ""
}


variable "domain_arn" {
  default = ""
}


variable "gateway_subnets" {
}
variable "alb_gateway_sg_ids" {
}
variable "open_api_subnets" {
}
variable "alb_open_api_sg_ids" {
}

