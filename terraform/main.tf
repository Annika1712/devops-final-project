module "AWS" {
  source = "./aws"

  # variables
  vpc_name     = "team-1-vpc"
  cluster_name = "team-1-eks"
  arn_administrators = [
    "arn:aws:iam::851725332718:user/annika",
    "arn:aws:iam::851725332718:user/olha",
    "arn:aws:iam::851725332718:user/chi",
    "arn:aws:iam::851725332718:user/frahan"
  ]

}

module "Kubernetes" {
  source     = "./k8s"
  depends_on = [module.AWS]

  # variables
  cluster_name = module.AWS.cluster_name
  alb_irsa     = module.AWS.irsa_alb

}