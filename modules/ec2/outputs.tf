output "block_explorer_ip_address" {
  value = aws_eip.block_explorer.public_ip
}

output "seed_ip_address_1" {
  value = aws_eip.seed_1.public_ip
}

# output "seed_ip_address_2" {
#   value = aws_instance.seed_2.public_ip
# }

# output "seed_ip_address_3" {
#   value = aws_instance.seed_3.public_ip
# }

