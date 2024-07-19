#####################################################
# User Access
#####################################################

# Administrator Access
resource "aws_eks_access_entry" "Admin" {
  for_each      = var.arn_administrators
  cluster_name  = module.eks.cluster_name
  principal_arn = each.key
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "Admin" {
  for_each     = aws_eks_access_entry.Admin
  cluster_name = module.eks.cluster_name
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html#access-policy-permissions
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
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
# Github Access
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
    "sts.amazonaws.com"
  ]

  thumbprint_list = [data.tls_certificate.Github_Actions.certificates[0].sha1_fingerprint]
}

# Role to provide access to EKS Cluster, Trust policy included
# https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html#idp_oidc_Create_GitHub
# https://aws.amazon.com/blogs/security/how-to-use-trust-policies-with-iam-roles/ for setting up the trust policy when the session gets deleted every time
resource "aws_iam_role" "github_oidc_development" {
  name = "eks_github_oidc-${module.eks.cluster_name}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Principal" : {
          "Federated" : "arn:aws:iam::851725332718:oidc-provider/token.actions.githubusercontent.com"
        },
        "Condition" : {
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud" : [
              "sts.amazonaws.com"
            ],
            #             "token.actions.githubusercontent.com:sub" : [
            #               "repo:Annika1712/devops-final-project:ref:refs/heads/annika/terraform/iam-cicd"
            #             ]
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub" : "repo:Annika1712/devops-final-project:*"
          }
        }
      },
      {
        "Sid" : "Allow",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : [
            "arn:aws:iam::851725332718:root"
          ]
        },
        "Action" : "sts:AssumeRole",
        "Condition" : {
          "ArnEquals" : {
            "aws:PrincipalArn" : "arn:aws:iam::851725332718:role/eks_github_oidc-${module.eks.cluster_name}"
          }
        }

      }
    ]
  })
}

# Provide edit access to the EKS Cluster
resource "aws_iam_policy" "EKS_Access" {
  name        = "EKS_policy"
  description = "Permission to access EKSCluster"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "EKSAccess",
        "Effect" : "Allow",
        "Action" : [
          "eks:DescribeCluster"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AssumeRole",
        "Effect" : "Allow",
        "Action" : "sts:AssumeRole",
        "Resource" : "*"
      }
    ]
  })
}

# Associate EKS Access policy with the role
resource "aws_iam_role_policy_attachment" "Github_OIDC" {
  role       = aws_iam_role.github_oidc_development.name
  policy_arn = aws_iam_policy.EKS_Access.arn
}

# Access Entries to EKS Cluster associate it with AWS Role
resource "aws_eks_access_entry" "GithubActions" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_iam_role.github_oidc_development.arn
}

# Access Entries to EKS Cluster --> Kubernetes RBAC
resource "aws_eks_access_policy_association" "GitHubActions" {
  cluster_name = module.eks.cluster_name
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html#access-policy-permissions
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
  principal_arn = aws_eks_access_entry.GithubActions.principal_arn

  access_scope {
    type       = "namespace"
    namespaces = ["development"]
  }
}


