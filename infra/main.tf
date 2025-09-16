provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "./modules/vpc"
  project         = var.project
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "security_groups" {
  source    = "./modules/security_groups"
  project   = "crediya"
  vpc_id    = module.vpc.vpc_id
  rds_port  = 3306
  vpc_cidrs = ["10.0.0.0/16"]
}
