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
  vpc_name     = "team-1-fp-vpc"

  # EKS configs
  cluster_name = "team-1-fp-eks-${random_string.suffix.result}"
  instance_type = "t2.micro"
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

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

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
}

# IAM Policy that allows the CSI driver service account to make calls to related services such as EC2 on your behalf.
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEBSCSIDriverPolicy.html
# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# iam-assumable-role-with-oidc - this is Terraform submodule for IAM module to create AWS IAM resources
# IAM module documentation -> https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
# GitHub repo -> https://github.com/terraform-aws-modules/terraform-aws-iam/blob/v5.41.0/modules/iam-assumable-role-with-oidc/README.md
module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.41.0"

  create_role                   = true
  role_name                     = "AwsEKSEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}



module "alb_ingress_controller"{
  source = "iplabs/alb-ingress-controller/kubernetes"
  version = "3.4.0"
  k8s_cluster_name = local.cluster_name
  k8s_namespace = "development"
  k8s_cluster_type = "eks"
}
