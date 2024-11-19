terraform {
  backend "s3" {
    bucket         = "prd-aws-tf-state-backend"
    key            = "terraform/prd/route53/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prd-aws-tf-state-locks"
    encrypt        = true
  }
  required_version = ">= 1.6.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "Project"     = var.project,
      "Environment" = var.environment,
      "Team"        = var.team,
      "DeployedBy"  = var.deployedby,
      "Application" = var.application,
      "OwnerEmail"  = var.email
    }
  }
}