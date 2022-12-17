keyvaults = {
    kv-storage = {
      name               = "dev-common-storage-kv2"
      resource_group_key = "common_rg"
      sku_name           = "standard"
      purge_protection_enabled = true
    }
}

keyvault_access_policies = {
  # A maximum of 16 access policies per keyvault
  kv-storage = {
    stg = {
      storage_account_key = "sa1"
      key_permissions     = ["get", "create", "list", "restore", "recover", "unwrapkey", "wrapkey", "purge", "encrypt", "decrypt", "sign", "verify"]
      secret_permissions  = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
    }
  }
}
keyvault_keys = {
  masimo = {
    name         = "storage"
    keyvault_key = "kv-storage"
    key_type     = "RSA"
    key_size     = 2048
    key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]
  }
}

storage_accounts = {
  sa1 = {
    name               = "masimodevstorage"
    resource_group_key = "common_rg"
    # Account types are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. Defaults to StorageV2
    account_kind = "StorageV2"
    # Account Tier options are Standard and Premium. For BlockBlobStorage and FileStorage accounts only Premium is valid.
    account_tier = "Standard"
    #  Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS
    account_replication_type = "LRS" # https://docs.microsoft.com/en-us/azure/storage/common/storage-redundancy
    tags = {
      environment = "dev"
      team        = "IT"
      ##
    }
    containers = {
      tenable = {
        name = "tenable"
      }
      xdr = {
        name = "xdr"
      }
    }
    file_shares = {
      api = {
        name = "api"
      }
      web = {
        name = "web"
      }
    }

    enable_system_msi = true
    # customer_managed_key = {
    #   keyvault_key = "kv-storage"
    #   keyvault_key_key = "masimo"

    # }
  }
}