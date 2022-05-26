module "validator" {
  source        = "./modules/validator"
  env           = var.env
  project       = var.project
  ssh_keypair   = var.ssh_keypair
  vpc_id        = aws_vpc.vpc.id
  igw_id        = aws_internet_gateway.igw.id
  subnet_cidr   = var.validator_subnet_cidr
  ami           = data.aws_ami.latest-ubuntu.id
  num_instances = 3
}

module "seed" {
  source        = "./modules/seed"
  env           = var.env
  project       = var.project
  ssh_keypair   = var.ssh_keypair
  vpc_id        = aws_vpc.vpc.id
  igw_id        = aws_internet_gateway.igw.id
  subnet_cidr   = var.validator_subnet_cidr
  ami           = data.aws_ami.latest-ubuntu.id
  num_instances = 3
}

module "explorer" {
  source      = "./modules/explorer"
  env         = var.env
  project     = var.project
  ssh_keypair = var.ssh_keypair
  vpc_id      = aws_vpc.vpc.id
  igw_id      = aws_internet_gateway.igw.id
  subnet_cidr = var.explorer_subnet_cidr
  ami         = data.aws_ami.latest-ubuntu.id
}

