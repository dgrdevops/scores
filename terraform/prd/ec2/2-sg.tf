data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "prd-aws-tf-state-backend"
    key    = "terraform/prd/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "gha_sg" {
  name        = "${var.env}-${var.application}-sg"
  description = "${var.env}-${var.application}-sg"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    description = "Allow from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.env}-${var.application}-sg"
  }
}