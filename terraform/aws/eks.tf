resource "random_string" "suffix" {
  length  = 8
  special = false
}

# eks - this is Terraform module to create AWS EKS resources
# Documentation -> https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest
# GitHub repo -> https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/README.md
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.17.2"

  cluster_name    = "${var.cluster_name}-${random_string.suffix.result}"
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

      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"

      instance_types = [var.instance_type]

      min_size     = 1
      max_size     = 2
      desired_size = 1
    }

    three = {
      name = "node-group-3"

      instance_types = [var.instance_type]

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