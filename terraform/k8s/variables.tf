variable "cluster_name" {
  description = "EKS cluster name (a suffix will be added to the end as unique identifier)"
  type = string
  default = "team-1-eks"
  
}

variable "alb_irsa" {
  description = "arn of IAM account for the AWS Application Loadbalancer (Ingress with AWS ALB integration)"
  type = string
  default = "AwsEKSALBIngressControllerRole-team-1-eks"
}

variable "namespace" {
  description = "names of namespaces that need to be created"
  type = set(string)
  default = ["production", "development", "staging", "monitoring"]
}