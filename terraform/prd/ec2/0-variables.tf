
variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "project" {
  description = "Working project"
  default     = "terraform ec2"
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
  default     = "devops-gha-runner"
}

variable "email" {
  description = "Owner email"
  default     = "devops@demo.com"
}
