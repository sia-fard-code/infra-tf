
dns_zones = {
  masimosafetynetintegration = {
    name               = "masimosafetynetintegration.com" 
    resource_group_key = "dns_rec_common_rg"

    records = {
      a = {
        web-b = {
          name    = "www-b"
          ttl     = 60
          records = ["40.64.98.67"]
        }
        api-b = {
          name    = "app-b"
          ttl     = 60
          records = ["40.64.98.67"]
        }
      }
      cname = {
        web = {
          name    = "*"
          ttl     = 60
          record = "www-b.masimosafetynetintegration.com"
        }
        api = {
          name    = "app"
          ttl     = 60
          record = "app-b.masimosafetynetintegration.com"
        }
      }  
    }
  }
}
