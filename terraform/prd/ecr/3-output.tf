output "ecr_repo_arn" {
  value       = aws_ecr_repository.scores_repo.arn
  description = "ECR repo arn"
}