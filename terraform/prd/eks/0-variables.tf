locals {
  application_name   = "devops-eks"
  eks_version        = "1.31"
  ebs_driver_version = "v1.36.0-eksbuild.1"
  efs_driver_version = "v2.0.8-eksbuild.1"
}

variable "env" {
  description = "Working environment short"
  default     = "prd"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "project" {
  description = "Working project"
  default     = "terraform"
  type        = string
}

variable "environment" {
  description = "Working environment"
  default     = "production"
  type        = string
}

variable "team" {
  description = "Working team"
  default     = "devops"
  type        = string
}

variable "deployedby" {
  description = "Deployed by"
  default     = "terraform"
  type        = string
}

variable "application" {
  description = "Application"
  default     = "devops"
  type        = string
}

variable "email" {
  description = "Owner email"
  default     = "devops@demo.com"
  type        = string
}