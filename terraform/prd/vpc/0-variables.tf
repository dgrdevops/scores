locals {
  zone1               = "us-east-1a"
  zone2               = "us-east-1b"
  cidr_block          = "10.0.0.0/16"
  cidr_block_private1 = "10.0.0.0/19"
  cidr_block_private2 = "10.0.32.0/19"
  cidr_block_public1  = "10.0.64.0/19"
  cidr_block_public2  = "10.0.96.0/19"
  application_name    = "devops"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  description = "Working project"
  default     = "terraform networking"
}

variable "environment" {
  description = "Working environment"
  default     = "production"
}

variable "env" {
  description = "Working environment short"
  default     = "prd"
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
  default     = "vpc"
}

variable "email" {
  description = "Owner email"
  default     = "devops@demo.com"
}
