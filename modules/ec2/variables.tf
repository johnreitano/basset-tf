variable "env" {
  description = "Deployment Environment"
}

variable "project" {
  description = "Project name"
}

variable "ssh_keypair" {
  description = "SSH keypair to use for EC2 instance"
}

variable "public_subnet_id" {
  description = "id of the public subnet"
}

variable "public_sg_id" {
  description = "id of the public security group"
}

variable "validator_subnet_id" {
  description = "id of the validator subnet"
}

variable "validator_sg_id" {
  description = "id of the validator security group"
}

