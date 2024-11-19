resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.cidr_block_private1
  availability_zone       = local.zone1
  map_public_ip_on_launch = false

  tags = {
    "Name"                                                           = "${var.env}-${local.application_name}-private-${local.zone1}"
    "kubernetes.io/role/internal-elb"                                = "1"
    "kubernetes.io/cluster/${var.env}-${local.application_name}-eks" = "owned"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.cidr_block_private2
  availability_zone       = local.zone2
  map_public_ip_on_launch = false

  tags = {
    "Name"                                                           = "${var.env}-${local.application_name}-private-${local.zone2}"
    "kubernetes.io/role/internal-elb"                                = "1"
    "kubernetes.io/cluster/${var.env}-${local.application_name}-eks" = "owned"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.cidr_block_public1
  availability_zone       = local.zone1
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                           = "${var.env}-${local.application_name}-public-${local.zone1}"
    "kubernetes.io/role/elb"                                         = "1"
    "kubernetes.io/cluster/${var.env}-${local.application_name}-eks" = "owned"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.cidr_block_public2
  availability_zone       = local.zone2
  map_public_ip_on_launch = true

  tags = {
    "Name"                                                           = "${var.env}-${local.application_name}-public-${local.zone2}"
    "kubernetes.io/role/elb"                                         = "1"
    "kubernetes.io/cluster/${var.env}-${local.application_name}-eks" = "owned"
  }
}
