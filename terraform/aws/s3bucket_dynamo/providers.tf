terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.53.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region = "eu-central-1"
}