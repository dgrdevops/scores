variable "env" {
  description = "Working environment short"
  default     = "prd"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  description = "Working project"
  default     = "terraform"
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
  default     = "devops-db"
}

variable "email" {
  description = "Owner email"
  default     = "devops@demo.com"
}