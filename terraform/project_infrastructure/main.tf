provider "aws" {
  region = var.region
}

# Filter out local zones, which are not currently supported with managed node groups
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  # Network configs
  vpc_name = "team-1-fp-vpc"

  # EKS configs
  cluster_name  = "team-1-fp-eks-${random_string.suffix.result}"
  instance_type = "t3.medium"

}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

# vpc - this is Terraform module to create AWS VPC resources
# Documentation -> https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# GitHub repo -> https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/v2.15.0/README.md
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.9.0"

  name = local.vpc_name

  cidr = "10.0.0.0/16"
  azs  = slice(data.aws_availability_zones.available.names, 0, 2)

  #   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  #   public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  private_subnets = ["10.0.1.0/24", "10.0.5.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# eks - this is Terraform module to create AWS EKS resources
# Documentation -> https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
# GitHub repo -> https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.17.2"

  cluster_name    = local.cluster_name
  cluster_version = "1.30"

  cluster_endpoint_public_access = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }
  enable_irsa = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = [local.instance_type]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = [local.instance_type]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    three = {
      name = "node-group-3"

      instance_types = [local.instance_type]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }

  # KMS - needed for secrets in Kubernetes - https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/
  kms_key_administrators = tolist(var.arn_administrators)
  # If required by Github, but I think not
  kms_key_service_users = []

}


