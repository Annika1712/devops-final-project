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