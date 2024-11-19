output "ec2_devops_gha_runner_private_ip" {
  value       = aws_instance.gha_runner.private_ip
  description = "Private subnet CIDR block"
}

output "ec2_devops_gha_runner_sg_id" {
  value       = aws_security_group.gha_sg.id
  description = "Github actions runner security group ID"
}