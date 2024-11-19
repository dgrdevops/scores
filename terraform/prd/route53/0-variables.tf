variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Domain name"
  default     = "*.scores.xyz"
}

variable "environment" {
  description = "Working environment"
  default     = "production"
}

variable "env" {
  description = "Working environment short"
  default     = "prd"
}

variable "project" {
  description = "Working project"
  default     = "terraform hosted zone"
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
  default     = "scores"
}

variable "email" {
  description = "Owner email"
  default     = "devops@demo.com"
}
