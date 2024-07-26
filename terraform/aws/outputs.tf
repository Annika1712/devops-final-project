output "irsa_alb" {
  value = module.irsa_alb_ingress_controller.iam_role_arn

}

output "cluster_name" {
  value = module.eks.cluster_name
}