resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Environment = var.env
    Project     = var.project
    Name        = "${var.project}-${var.env}-vpc"
  }
}
