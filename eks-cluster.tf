data "aws_eks_cluster" "gk-cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "gk-cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.gk-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.gk-cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.gk-cluster.token
}

module "eks" {
  source            = "terraform-aws-modules/eks/aws"
  version           = "17.20.0"
  
  cluster_name      = "gk-eks-cluster"
  cluster_version   = "1.21"

  subnets           = module.gk-eks-vpc.private_subnets
  vpc_id            = module.gk-eks-vpc.vpc_id
  
  tags = {
      environment   = "development"
      application   = "gk-eks"
  }

  worker_groups = [
    {
      name                          = "frontend-group"
      instance_type                 = var.node_type_frontend
      asg_desired_capacity          = 2
    },
    {
      name                          = "backend-group"
      instance_type                 = var.node_type_backend
      asg_desired_capacity          = 1
    },
  ]
}