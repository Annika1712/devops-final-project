#####################################################
# User Access
#####################################################

# Administrator Access
resource "aws_eks_access_entry" "Admin" {
  for_each = var.arn_administrators
  cluster_name = module.eks.cluster_name
  principal_arn = each.key
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "Admin" {
  for_each = aws_eks_access_entry.Admin
  cluster_name = module.eks.cluster_name
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html#access-policy-permissions
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.Admin[each.key].principal_arn

  access_scope {
    type = "cluster"
  }
}

#########################################################
# EKS Services Access 
#########################################################

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

#########################################################
# Third party
#########################################################
# Retrieving SSl certificate for OIDC setup of Github Actions
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate
data "tls_certificate" "Github_Actions" {
  url = "https://token.actions.githubusercontent.com"
}

# OIDC Provider - Github Actions
resource "aws_iam_openid_connect_provider" "GitHub_Actions" {
  url = data.tls_certificate.Github_Actions.url

  client_id_list = [
    # To reduce latency, build in redundancy, and increase session token validity: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_temp_enable-regions.html
    "sts.amazonaws.com"
  ]

  thumbprint_list = [data.tls_certificate.Github_Actions.certificates[0].sha1_fingerprint]
}

# GitHUb Actions role for development stage
module "Github_Actions_development_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.41.0"

  create_role                   = true
  role_name                     = "devs-GitHubActions-${module.eks.cluster_name}"
  provider_url                  = aws_iam_openid_connect_provider.GitHub_Actions.url
  # https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html#idp_oidc_Create_GitHub
  oidc_fully_qualified_subjects = ["repo:Annika1712/devops-final-project:ref:refs/heads/annika/terraform/iam"]
  oidc_fully_qualified_audiences = aws_iam_openid_connect_provider.GitHub_Actions.client_id_list
}

resource "aws_eks_access_entry" "GithubActions" {
  cluster_name = module.eks.cluster_name
  principal_arn = module.Github_Actions_development_role.iam_role_arn
}

resource "aws_eks_access_policy_association" "GitHubActions" {
  cluster_name = module.eks.cluster_name
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html#access-policy-permissions
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
  principal_arn = aws_eks_access_entry.GithubActions.principal_arn

  access_scope {
    type = "namespace"
    namespaces = ["development"]
  }
}


