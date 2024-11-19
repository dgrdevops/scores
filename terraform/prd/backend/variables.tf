variable "env" {
  description = "Working environment short"
  default     = "prd"
}

variable "aws_region" {
  description = "AWS Region for the S3 and DynamoDB"
  default     = "us-east-1"
}

variable "project" {
  description = "Working project"
  default     = "terraform backend"
}

variable "environment" {
  description = "Working environment"
  default     = "production"
}

variable "team" {
  description = "Working team"
  default     = "devops"
}

variable "deployedby" {
  description = "Deployed by"
  default     = "terraform"
}

variable "application" {
  description = "Application"
  default     = "terraform"
}

variable "email" {
  description = "Owner email"
  default     = "devops@demo.com"
}

variable "state_bucket" {
  description = "S3 bucket for holding Terraform state files. Must be globally unique."
  type        = string
  default     = "prd-aws-tf-state-backend"
}

variable "dynamodb_table" {
  description = "DynamoDB table for locking Terraform states"
  type        = string
  default     = "prd-aws-tf-state-locks"
}