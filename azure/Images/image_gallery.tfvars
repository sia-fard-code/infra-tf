
global_settings = {
  default_region = "region1"
  regions = {
    region1 = "westus2"
    # region2 =
  }
  random_length  = 0
  environment = "dev"
  useprefix   = false
  prefix = ""
}



# resource_groups = {
#   images_rg = {
#     name = "images-dev"
#   }
# }

shared_image_galleries = {
  gallery1 = {
    name               = "_dev_common_msn"
    resource_group_key = "images_rg"
    description        = " "
  }
}

image_definitions = {
  image1 = {
    name               = "_dev_common_msn_mongo"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo"
    offer              = "Images"
    sku                = "2021.1"
  }
  
  image-api-v = {
    name               = "_dev_common_msn_api_v"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo-APIV"
    offer              = "Images"
    sku                = "2021.1"
  }

  image-web-v = {
    name               = "_dev_common_msn_web_v"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo-WEBV"
    offer              = "Images"
    sku                = "2021.1"
  }

  image-adminapp-v = {
    name               = "_dev_common_msn_adminapp_v"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo-ADMV"
    offer              = "Images"
    sku                = "2021.1"
  }
   
  image-api-e = {
    name               = "_dev_common_msn_api_e"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo-APIE"
    offer              = "Images"
    sku                = "2021.1"
  }

  image-web-e = {
    name               = "_dev_common_msn_web_e"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo-WEBE"
    offer              = "Images"
    sku                = "2021.1"
  }

  image-adminapp-e = {
    name               = "_dev_common_msn_adminapp_e"
    gallery_key        = "gallery1"
    resource_group_key = "images_rg"
    os_type            = "Linux"
    publisher          = "Masimo-ADME"
    offer              = "Images"
    sku                = "2021.1"
  }
}