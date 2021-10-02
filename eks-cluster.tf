module "eks" {
  source            = "terraform-aws-modules/eks/aws"
  version           = "17.20.0"
  
  cluster_name      = "gk-eks-cluster"
  cluster_version   = "1.22"

  subnets           = module.gk-eks-vpc.private_subnets
  vpc_id            = module.gk-eks-vpc.vpc_id
  
  tags = {
      environment   = "development"
      application   = "gk-eks"
  }

}