output "eks_kubectl_auth" {
  value       = "aws eks update-kubeconfig --name ${aws_eks_cluster.eks.name} --region ${var.aws_region}"
  description = "Run the following command to connect to the EKS cluster"
}

output "eks_cluster_arn" {
  value       = aws_eks_cluster.eks.arn
  description = "EKS Cluster ARN"
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.eks.endpoint
  description = "EKS Cluster Endpoint"
}

output "eks_cluster_security_group_id" {
  value       = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  description = "EKS Cluster Security Group ID"
}