terraform {
    required_providers {
      # aws - this is official public cloud provider for AWS by HashiCorp
    # Lifecycle management of AWS resources, including EC2, Lambda, EKS, ECS, VPC, S3, RDS, DynamoDB, and more.
    # This provider is maintained internally by the HashiCorp AWS Provider team.
    # Documentation -> https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58.0"
    }
    }
    backend "s3" {
    bucket         = "team1-remotestate"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "team1-db_name"
  }
}

provider "aws" {
  region = "eu-central-1"
}
