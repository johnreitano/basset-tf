output "block_explorer_ip_address" {
  value = module.ec2.block_explorer_ip_address
}

output "seed_ip_address_1" {
  value = module.ec2.seed_ip_address_1
}

# output "seed_ip_address_2" {
#   value = module.ec2.seed_ip_address_2
# }

# output "seed_ip_address_3" {
#   value = module.ec2.seed_ip_address_3
# }


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
