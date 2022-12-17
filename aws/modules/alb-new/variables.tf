variable "env" {
  default = "dev"
}
variable "type" {
  default = "BLUE"
}

variable "common_enabled" {
  default = false
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
variable "msn_svc_enabled" {
  default = false
}
variable "msn_open_enabled" {
  default = false
}


variable "msn_prefix" {
  default = "-MSN"
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

variable "open_api_https_prv_arn" {
  default = ""
}

variable "api_https_prv_arn" {
  default = ""
}
variable "tags" {
  type        = list(object({ key = string, value = string, propagate_at_launch = bool }))
  default     = []
  description = "A list of tags to associate to the asg instance."
}

variable "msn_th_enabled" {
  default = false
}
