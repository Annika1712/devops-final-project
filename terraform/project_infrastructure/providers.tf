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

    # random - this is official utility by HashiCorp
    # Supports the use of randomness within Terraform configurations. This is a logical provider, which means that it
    # works entirely within Terraform logic, and does not interact with any other services.
    # Documentation -> https://registry.terraform.io/providers/hashicorp/random/latest/docs
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }

    # tls - this is official utility by HashiCorp
    # Provides utilities for working with Transport Layer Security keys and certificates. It provides resources
    # that allow private keys, certificates and certficate requests to be created as part of a Terraform deployment.
    # Documentation -> https://registry.terraform.io/providers/hashicorp/tls/latest/docs
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    # cloudinit - this is official utility by HashiCorp
    # Exposes the cloudinit_config data source which renders a multipart MIME configuration for use
    # with cloud-init (previously available as the template_cloudinit_config resource in the template provider).
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.6.0"
    }
  }

  required_version = "~> 1.3"
  backend "s3" {
    bucket         = "team1-remotestate"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "team1-db_name"
  }
}

