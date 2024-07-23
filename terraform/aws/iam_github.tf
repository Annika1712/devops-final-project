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