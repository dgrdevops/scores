output "private_subnet1" {
  value       = aws_subnet.private_subnet1.cidr_block
  description = "Private subnet CIDR block"
}

output "private_subnet2" {
  value       = aws_subnet.private_subnet2.cidr_block
  description = "Private subnet CIDR block"
}

output "private_subnet1_id" {
  value       = aws_subnet.private_subnet1.id
  description = "Private subnet CIDR block"
}

output "private_subnet2_id" {
  value       = aws_subnet.private_subnet2.id
  description = "Private subnet CIDR block"
}

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "vpc_cidr_block" {
  value       = aws_vpc.vpc.cidr_block
  description = "VPC CIDR block"
}
