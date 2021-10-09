## Terraform-EKS-cluster
### Author: GamKon

Deploys Kubernetes cluster with Terraform.<br>
Using community [VPC](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest) and [EKS](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest) modules.<br>
Three AZs.<br>
Two node groups.

    - Forntend group in public subnets.
    - Backend group in private subnets.

Uses remote state in S3 bucket.<br>
Uses environment variables for authentification.

Command to run: 

***terraform init && terraform apply -auto-approve***
