variable "env" {
  description = "Deployment Environment"
}

variable "project" {
  description = "Project name"
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
}

variable "validator_subnet_cidr" {
  description = "CIDR block for validator subnet"
}

variable "db_subnet_cidr" {
  description = "CIDR block for db subnet"
}

variable "region" {
  description = "Region in which the bastion host will be launched"
}
