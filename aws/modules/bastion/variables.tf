variable "ami" {
}

variable "instance_type" {
  default = "t2.micro"
}

variable "env" {
  default = "dev"
}

variable "name" {
  default = "bastion"
}

variable "allowed_cidr" {
  default = ["0.0.0.0/0"]
}




variable "s3_bucket_name" {
  default = ""
}

variable "ssh_user" {
  default = "ubuntu"
}



variable "region" {
  default = "us-west-2"
}

variable "vpc_id" {
}

variable "eip_id" {
  default = ""
}

variable "eip_ip" {
  default = ""
}

variable "security_group_ids" {
  description = "Comma seperated list of security groups to apply to the bastion."
  default     = ""
}

variable "subnet_ids" {
  default     = []
  description = "A list of subnet ids"
}


variable "associate_public_ip_address" {
  default = false
}

variable "key_name" {
  default = ""
}

variable "iam_instance_profile" {
  default = ""
}


variable "elb" {
  default = "bastion"
}
