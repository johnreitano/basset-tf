output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "validator_subnet_id" {
  value = aws_subnet.validator.id
}

output "db_subnet_id" {
  value = aws_subnet.db.id
}

output "public_sg_id" {
  value = aws_security_group.public.id
}

output "validator_sg_id" {
  value = aws_security_group.validator.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "public_route_table" {
  value = aws_route_table.public.id
}

output "eip_address" {
  value = aws_eip.nat_eip.public_ip
  # value = "zzz"
}



