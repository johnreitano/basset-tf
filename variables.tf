variable "region" {
  description = "AWS region"
  default     = "us-west-2"
  type        = string
}

variable "profile" {
  description = "AWS profile"
  default     = "default"
  type        = string
}
variable "env" {
  description = "The env - either 'test' or 'main' -- used as suffix of resource names"
  default     = "test"
  type        = string
}

variable "project" {
  description = "The name of this project -- used as prefix of resource names"
  default     = "basset"
  type        = string
}

variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
  default     = "john-pubkey"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  default     = "10.0.1.0/24"
}

variable "validator_subnet_cidr" {
  description = "CIDR block for validator subnet"
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR block for db subnet"
  default     = "10.0.3.0/24"
}
