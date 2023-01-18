# Terraform Block
terraform {
  required_version = "~> 1.0"
  required_providers {
    # AWS Provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    # Random Provider
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

# Provider Config Block
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

