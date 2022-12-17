variable "alb_target_group_arn" {
  type = map(list(string))
  default = {}
}
variable "lt_tag" {
  default = "tag"
}
variable "desired_capacity" {
  default = "2"
}
variable "min_size" {
  default = "1"
}
variable "max_size" {
  default = "2"
}
variable "iam_instance_profile_arn" {
  default = ""
}

variable "deployment_map" {
  default = [
    "BLUE",
    "GREEN",
    "COMMON"
  ]
}




variable "allowed_cidr" {
  type = list(string)

  default = [
    "0.0.0.0/0",
  ]

  description = "A list of CIDR Networks to allow ssh access to."
}

variable "allowed_ipv6_cidr" {
  type = list(string)

  default = [
    "::/0",
  ]

  description = "A list of IPv6 CIDR Networks to allow ssh access to."
}

variable "allowed_security_groups" {
  type        = list(string)
  default     = []
  description = "A list of Security Group ID's to allow access to."
}

variable "name" {
  type = list(string)
}

variable "tags" {
//  type        = list(object({ key = string, value = string, propagate_at_launch = bool }))
  type        = map(string)
  default     = {}
  description = "A list of tags to associate to the asg instance."
}

variable "ami" {
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_volume_size_gb" {
  description = "The root volume size, in gigabytes"
  default     = "8"
}

variable "iam_instance_profile" {
  default = ""
}

variable "user_data_file" {
  default = "user_data.sh"
}
variable "user_data" {
  default = ""
}


variable "s3_bucket_name" {
  default = ""
}

variable "s3_bucket_uri" {
  default = ""
}

variable "enable_monitoring" {
  default = true
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "enable_hourly_cron_updates" {
  default = "false"
}

variable "keys_update_frequency" {
  default = ""
}

variable "additional_user_data_script" {
  default = ""
}

variable "region" {
  default = "eu-west-1"
}

variable "vpc_id" {
  default = "asg"
}

variable "vpc_security_group_ids" {
  description = "Comma seperated list of security groups to apply to the asg."
  default     = ""
}

variable "security_group_names" {
  description = "Comma seperated list of security groups to apply to the asg."
  default     = ""
}


variable "subnet_ids" {
  default     = []
  description = "A list of subnet ids"
}

variable "eip" {
  default = ""
}

variable "associate_public_ip_address" {
  default = false
}

variable "key_name" {
  default = ""
}

variable "apply_changes_immediately" {
  description = "Whether to apply the changes at once and recreate auto-scaling group"
  default     = false
}
variable "tg_arn" {
  default = ""
}
