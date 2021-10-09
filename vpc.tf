provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket  = "terraform-state-files-gamkon"
    key     = "Terraform-gk-eks-cluster/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_availability_zones" "azs" {}
  

module "gk-eks-vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "3.7.0"
  
  name                  = "gk-eks-vpc"
  cidr                  = var.vpc_cidr_block
  public_subnets        = var.public_subnets
  private_subnets       = var.private_subnets
  azs                   = data.aws_availability_zones.azs.names
  
  enable_nat_gateway    = true
  single_nat_gateway    = true
  enable_dns_hostnames  = true

  tags                  = {
    "kubernetes.io/cluster/gk-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/gk-eks-cluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/gk-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

output "public_subnets" {
  value = module.gk-eks-vpc.public_subnets
}

output "private_subnets" {
  value = module.gk-eks-vpc.private_subnets
}