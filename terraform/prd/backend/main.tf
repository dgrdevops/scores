terraform {
  backend "s3" {
    bucket         = "prd-aws-tf-state-backend"
    key            = "terraform/prd/backend/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "prd-aws-tf-state-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.69"
    }
  }
  required_version = ">= 1.6.2"
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "Project"     = var.project,
      "Environment" = var.environment,
      "Team"        = var.team,
      "Deployedby"  = var.deployedby,
      "Application" = var.application,
      "OwnerEmail"  = var.email
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_locks" {
  name         = var.dynamodb_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    "Name"        = var.dynamodb_table
    "description" = "DynamoDB terraform table to lock states"
  }
}

resource "aws_kms_key" "terraform_state_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10

  tags = {
    "Name" = "${var.env}-${var.application}-kms"
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket              = var.state_bucket
  object_lock_enabled = true
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = var.state_bucket
    description = "S3 Remote Terraform State Store"
  }
}

resource "aws_s3_bucket_versioning" "terraform_s3_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_access_block" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
