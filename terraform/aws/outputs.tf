output "irsa_alb" {
  value = module.irsa_alb_ingress_controller.iam_role_arn

}

output "github_role_arn" {
  value = aws_iam_role.github_oidc_development.arn
}

output "cluster_name" {
  value = module.eks.cluster_name
}



