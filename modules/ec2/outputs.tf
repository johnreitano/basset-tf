output "block_explorer_ip_address" {
  value = aws_eip.block_explorer.public_ip
}

output "seed_ip_address_1" {
  value = aws_eip.seed_1.public_ip
}

output "validator_ip_address_1" {
  value = aws_eip.validator_1.public_ip
}

