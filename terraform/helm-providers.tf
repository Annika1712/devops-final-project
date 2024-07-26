data "aws_eks_cluster" "target" {
  name = module.AWS.cluster_name
}

# Retrieving your user account authentication against the EKS cluster (with aws provider, which you already authenticated)
data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.aws_eks_cluster.target.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token

}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  }
}
