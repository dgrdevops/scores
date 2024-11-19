resource "aws_vpc" "vpc" {
  cidr_block = local.cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.env}-${local.application_name}-vpc"
  }
}