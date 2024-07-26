variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

# VPC variables
variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "team-1-fp-vpc"
}

# EKS variables
variable "cluster_name" {
  description = "EKS cluster name (a suffix will be added to the end as unique identifier)"
  type        = string
  default     = "team-1-fp-eks"

}

variable "instance_type" {
  description = "EKS worker node instance type"
  type        = string
  default     = "t3.medium"

}

# IAM users
variable "arn_administrators" {
  description = "arn of all users that need ClusterAdmin Access to the EKS cluster, for example arn:aws:iam::111122223333:user/my-user. Run in CLI aws iam get-user or aws iam get-group"
  type        = set(string)
  default = [
    "arn:aws:iam::851725332718:user/annika",
    "arn:aws:iam::851725332718:user/olha",
    "arn:aws:iam::851725332718:user/chi",
    "arn:aws:iam::851725332718:user/frahan"
  ]

}

