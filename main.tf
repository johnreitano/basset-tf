module "network" {
  source                = "./modules/network"
  region                = var.region
  env                   = var.env
  project               = var.project
  vpc_cidr              = var.vpc_cidr
  public_subnet_cidr    = var.public_subnet_cidr
  validator_subnet_cidr = var.validator_subnet_cidr
  db_subnet_cidr        = var.db_subnet_cidr
}

module "ec2" {
  source      = "./modules/ec2"
  env         = var.env
  project     = var.project
  ssh_keypair = var.ssh_keypair

  public_subnet_id = module.network.public_subnet_id
  public_sg_id     = module.network.public_sg_id
}

