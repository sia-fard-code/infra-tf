output "kv-cert-id" {
  value = module.caf.keyvaults.masimo
}

output "vault_uri" {
  value = data.azurerm_key_vault.dev_kv
}
