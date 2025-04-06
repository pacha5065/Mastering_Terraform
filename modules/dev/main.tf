provider "aws" {
  region = var.region
}

module "vpc_module" {
  source                    = "../modules/network"
  cidr_block                = var.cidr_block
  public_subnet_cidr_block  = var.public_subnet_cidr_block
  private_subnet_cidr_block = var.private_subnet_cidr_block
  portslist                 = var.portslist
  region                    = var.region
  avialibility_zones        = var.avialibility_zones
  vpc_name                  = var.vpc_name
  # ami = var.ami
  # instance_type = var.instance_type
}

module "sec_group" {
  source     = "../modules/security_groups"
  cidr_block = var.cidr_block
  portslist  = var.portslist
  vpc_name   = var.vpc_name
  vpc_id     = module.vpc_module.vpc_id
}

module ec2{

  source = "../modules/compute"
  ami = var.ami
  instance_type = var.instance_type
  region = var.region
  public_subnet = module.vpc_module.public_subnet
}