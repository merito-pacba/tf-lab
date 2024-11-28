# Declare AWS provider for Terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

# Configuration settings for AWS provider
provider "aws" {
  region = "us-east-1"
}

