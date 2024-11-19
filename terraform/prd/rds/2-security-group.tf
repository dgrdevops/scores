data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "prd-aws-tf-state-backend"
    key    = "terraform/prd/eks/terraform.tfstate"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "prd-aws-tf-state-backend"
    key    = "terraform/prd/vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_security_group" "db_sg" {
  name   = "${var.env}-${var.application}-sg"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.terraform_remote_state.eks.outputs.eks_cluster_security_group_id]
    description     = "from prd-devops-eks"
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-${var.application}-sg"
  }
}