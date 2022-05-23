output "eip_address" {
  value = module.network.eip_address
}

# output "db_password" {
#   value     = module.database.db_config.password
#   sensitive = true
# }

# output "web_dns_name" {
#   value = module.web.dns_name
# }

# output "seed_dns_name" {
#   value = module.seed.seed_1_dns_name
# }
