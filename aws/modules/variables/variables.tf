variable "environment" {
}
variable "is_prod" {
  default = false
}
variable "is_dr" {
  default = false
}


variable "color" {
  default = "COMMON"
}
variable "region" {
}
variable "dns_zone_ids_map" {
  default = {
    DR      = "Z08792011CLULQ5YYKGSX"
    QA      = "Z010323425041DSU1AOIZ"
    QA0     = "Z06988831Q62ACNPCDL83"
    QA1     = "Z01848773KMHB6ZP563E1"
    INT0    = "Z012843721S7X8AL54XJM"
    INT1    = "Z02024629NLVI2FZ29W4"
    DEV     = "Z10427454O2TDNAQ9F66"
    DEV0    = "Z04972283IQV5QG0MRNYW"
    DR-DEV  = "Z04972283IQV5QG0MRNYW"
    DEV1    = "Z0056761368WB6LJDF46Z"
    DOC-DEV = "Z30MP8JYR7FLBA"
    PROD-US = "Z08792011CLULQ5YYKGSX"
    PROD-JP = "Z003532538KYGG3B9LPFL"
    PROD-CA = "Z06155721LGRX0GVDNSMT"
    PROD-EU = "Z05827703UZKCKNILI5A1"
    PROD-FR = "Z00647881TH6T7HPBZD66"
    PROD-SG = "Z013443637HTLFDR8CVNQ"
    DR-FR   = "Z00647881TH6T7HPBZD66"
    DR-US   = "Z08792011CLULQ5YYKGSX"
    DR-EU   = "Z05827703UZKCKNILI5A1"
    DR-JP   = "Z003532538KYGG3B9LPFL"
  }
}
output "dns_zone_ids" {
  value = lookup(var.dns_zone_ids_map, var.environment)
}
output "extra_tags" {
  value = {
        # TODO: remove Deployment and Group
        Deployment = var.color
        Group =  var.environment
        color = var.color
        env =  var.environment
        NEW =  "TRUE"
        product = "msn"
        module = "application"
        managed-by = "IaC"
        datadog-monitored = "true"
        designation = var.is_prod ? "A" : var.is_dr ? "B" : "C"
      }
  description = "A list of tags to associate to the asg instance."
}



variable "ssh_bastion_public_keys_map" {
  default = {
    ap-southeast-1 = {
      PROD-SG = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    ap-northeast-3 = {
      DR-JP = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    ap-northeast-1 = {
      PROD-JP = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    ca-central-1 = {
      PROD-CA = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    eu-central-1 = {
      PROD-EU = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    eu-west-1 = {
      DR-EU = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      DR-FR = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    eu-west-3 = {
      PROD-FR = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    us-east-2 = {
      DR-US = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    us-west-2 = {
      PROD-US = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      DEV0 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      DEV1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      DOC-DEV = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      QA0  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      QA  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      QA1  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      INT0 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      INT1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
    us-west-1 = {
      DEV = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
      DR-DEV = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9yy8UnMZc8oCeW6jozwdFK5tXfaALRgHUErgN53XkKEXTPj3HQjxZN1nsUqRS0W6Mgmg9IdHKoQ7Gc04VTBXcYHHwamkLEcrMTyo/Vu+VE5hMup4gRW0KlFsx0oX0jzBcctsS2y4ONElocqNEzPhTVgtkVkaSjz6JPVqNhJEw2NXt+1pU/zjZTuJMvImKev6MMbZLSjXrPu2ikeuDPPkHHBWxZNKHpp1nVggFGbn8cj858zP7nkuU2bFLhvEUO5BT1vUR50FevsKNeSnXcAf8KeMbpwmoGRNqNtpVmyWCDkt0q6lnJr6daeKSD52zrZtbCeCYSgYnPYbpmfNi8COH"
    }
  }
}
output "ssh_bastion_public_keys" {
  value = lookup(var.ssh_bastion_public_keys_map[var.region], var.environment)
}

variable "ssh_dev_public_keys_map" {
  default = {
    ap-southeast-1 = {
      PROD-SG = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    ap-northeast-1 = {
      PROD-JP = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    ap-northeast-3 = {
      DR-JP = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    ca-central-1 = {
      PROD-CA = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    eu-central-1 = {
      PROD-EU = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
      INT     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
    }
    us-east-2 = {
      DR-US = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    eu-west-1 = {
      DR-EU = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
      DR-FR = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    eu-west-3 = {
      PROD-FR = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
    }
    us-west-2 = {
      PROD-US = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCG9HHpXjzaVlms9NUYiYuOgkWPEF0IPc/1HOdRNeqQOUOgljHRAkfd6MpZH9bvrY5GVQRHzX981ZTp+egjS3NyNvgBOR0Kr1KCfn/Cu9Tt9E9+JZhjPxSHOworsKjqx+9/cmIECenMDEZCRKnSx1JwML89FN8ViLOvXbJMDZcE3+Ix7dACNmKQ4vBPVrxgIh74/RnTRZds4O5tEqFsgEdl8gik76KVaeyGWcRZtcW44q7vGypT0SOHukYQbztWl3q/DX2bUYmYhQ8gG62p/VIx2zYDqFh0s6XyQNlh3heshrRJQbQh8Z9NilUekb4ZwYxXsQl4/XeGAsd7gsrRDurF"
      QA  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      QA0  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      QA1  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      DEV0 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      DEV1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      DOC-DEV = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      INT0 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      INT1 = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
    }
    us-west-1 = {
      DEV = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
      DR-DEV = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYtsRXC/gxRRgaiaG/aa8IxTfJHhy3NvjY9S2qq61UuAkzeWhQdeAqH8RmRD3RptSgR3oTTR+pOuTGRdAZwgM3KYkumsyjBn7SBUBQ5+5SE8hFT2qTwzI30pYhDQEjq3JOBQudmAaHPiD2304u5d928cogFjOp4LebESd2CDFhVZOyfX6o/Et4AT+ojeWVaeAZUzCiPiVKI0aDGNrzYwnSo30esQAfLA4LlnXjoK+9A+laZqQBEsNISS1F6fS/TBp1JW5VTQrNHnir1GwifHccwxMj430R9N0l/f0p0TjvInIDcaVqKpjvlYguO9lVqVGRyECv//VLAlVsTg4laHLL"
    }
  }
}
output "ssh_dev_public_keys" {
  value = lookup(var.ssh_dev_public_keys_map[var.region], var.environment)
}

variable "db_instance_type_map" {
  default = {
    DR      = "r5a.4xlarge"
    QA      = "m5.xlarge"
    QA0     = "m5.xlarge"
    QA1     = "m5.xlarge"
    INT0    = "m5.xlarge"
    INT1    = "m5.xlarge"
    DEV     = "m5.xlarge"
    DR-DEV  = "m5.xlarge"
    DOC-DEV = "m5.xlarge"
    DEV0    = "m5.xlarge"
    DEV1    = "m5.xlarge"
    PROD-US = "r5a.4xlarge"
    PROD-CA = "r5a.4xlarge"
    PROD-JP = "r5a.4xlarge"
    PROD-EU = "r5a.4xlarge"
    PROD-FR = "r5.4xlarge"
    PROD-SG = "r5.4xlarge"
    DR-US = "r5a.4xlarge"
    DR-FR = "r5a.4xlarge"
    DR-EU = "r5a.4xlarge"
    DR-JP = "r5a.4xlarge"
  }
}
output "db_instance_type" {
  value = lookup(var.db_instance_type_map, var.environment)
}


variable "ubuntu_amis_map" {
  default = {
    eu-west-1    = "ami-089cc16f7f08c4457"
    eu-west-3    = "ami-0e67d9de5c9dad4a8"
    eu-central-1 = "ami-0d6be5935e0e03181"
    ca-central-1 = "ami-0699b674a53619db0"
    us-west-2    = "ami-04bb0cc469b2b81cc"
    us-west-1    = "ami-0f56279347d2fa43e"
    us-east-2    = "ami-0a63f96e85105c6d3"
    ap-northeast-3 = "ami-06c0c9c782372e5ca"
    ap-northeast-1 = "ami-046c23ecc3864999f"
    ap-southeast-2 = "ami-03495d0413362851a"
    ap-southeast-1 = "ami-05285e7f778920923"
  }
}
output "ubuntu_amis" {
  value = lookup(var.ubuntu_amis_map, var.region)
}

variable "admin_portal_amis_map" {
  default = {
    eu-central-1 = "ami-09fdbc5c82d41a459"
    ca-central-1 = "ami-04d8190b69658e3b3"
    eu-west-1    = "ami-089cc16f7f08c4457"
    us-west-2    = "ami-05de2c92bf720170d"
    us-east-2    = "ami-040f46749ba168c86"
    us-west-1    = "ami-0f56279347d2fa43e"
    eu-west-3    = "ami-0e67d9de5c9dad4a8"
    ap-northeast-3 = "ami-06c0c9c782372e5ca"
    ap-northeast-1 = "ami-046c23ecc3864999f"
    ap-southeast-2 = "ami-03495d0413362851a"
    ap-southeast-1 = "ami-05285e7f778920923"
  }
}
output "admin_portal_amis" {
  value = lookup(var.admin_portal_amis_map, var.region)
}


variable "vpc_cidrs_map" {
  default = {
     ap-southeast-1 = {
      PROD-SG = "10.60.0.0/16"
    }
     ap-northeast-1 = {
      PROD-JP = "10.50.0.0/16"
    }
     ap-northeast-3 = {
      DR-JP = "10.33.0.0/16"
    }
    ca-central-1 = {
      PROD-CA = "10.40.0.0/16"
    }
    eu-central-1 = {
      PROD-EU = "10.30.0.0/16"
      INT     = "10.20.0.0/20"
    }
    us-west-2 = {
      QA   = "10.20.0.0/16"
      QA0  = "10.20.0.0/16"
      QA1  = "10.23.0.0/16"
      DEV0 = "10.21.0.0/16"
      DEV1 = "10.22.0.0/16"
      DOC-DEV = "10.23.0.0/16"
      PROD-US = "10.30.0.0/16"
      INT0 = "10.21.0.0/16"
      INT1 = "10.22.0.0/16"
    }
    us-east-2 = {
      DR-US = "10.32.0.0/16"
    }
    eu-west-3 = {
      PROD-FR = "10.20.0.0/16"
    }
    eu-west-1 = {
      DR-EU = "10.31.0.0/16"
      DR-FR = "10.30.0.0/16"
    }
    us-west-1 = {
      DEV = "10.21.0.0/16"
      DR-DEV = "10.21.0.0/16"
    }
  }
}
output "vpc_cidrs" {
  value = lookup(var.vpc_cidrs_map[var.region], var.environment)
}

variable "top_level_domains_map" {
  default = {
     ap-southeast-1 = {
      PROD-SG = "sg"
    }
     ap-northeast-1 = {
      PROD-JP = "jp"
    }
     ap-northeast-3 = {
      DR-JP = "jp"
    }
    ca-central-1 = {
      PROD-CA = "ca"
    }
    eu-central-1 = {
      PROD-EU = "eu"
    }
    us-west-2 = {
      QA   = "com"
      QA0  = "com"
      QA1  = "com"
      DEV0 = "com"
      DEV1 = "com"
      DOC-DEV = "com"
      INT0 = "com"
      PROD-US = "com"
      INT1 = "com"
    }
    us-east-2 = {
      DR-US = "com"
    }
    eu-west-3 = {
      PROD-FR = "fr"
    }
    eu-west-1 = {
      DR-EU = "eu"
      DR-FR = "fr"
    }
    us-west-1 = {
      DEV = "com"
      DR-DEV = "com"
    }
  }
}
output "top_level_domains" {
  value = lookup(var.top_level_domains_map[var.region], var.environment)
}

variable "second_level_domains_map" {
  default = {
    DR-JP   = "masimosafetynet"
    DR      = "masimosafetynet"
    PROD-CA = "masimosafetynet"
    PROD-EU = "masimosafetynet"
    PROD-FR = "masimosafetynet"
    QA0     = "masimosafetynetqa"
    QA      = "masimosafetynetqa"
    DEV1    = "dev1-masimosn"
    DEV0    = "masimosafetynetdev"
    DR-DEV  = "masimosafetynetdev"
    INT     = "masimosafetynetintegration"
    INT0     = "masimosafetynetintegration"
    INT1    = "int1-masimosn"
    QA1     = "qa1-masimosn"
    DOC-DEV = "doctelladev"
    PROD-US = "masimosafetynet"
    PROD-JP = "masimosafetynet"
    DR-US = "masimosafetynet"
    PROD-SG = "masimosafetynet"
    DR-EU = "masimosafetynet"
    DR-FR = "masimosafetynet"
  }
}
output "second_level_domains" {
  value = var.second_level_domains_map[var.environment]
}
