output "db_secret_name" {
  value = aws_secretsmanager_secret.db_secret.name
}

output "eks_cluster_writer_endpoint" {
  value = aws_rds_cluster.database.endpoint
}

output "eks_cluster_reader_endpoint" {
  value = aws_rds_cluster.database.reader_endpoint
}

output "private_subnet_group_name" {
  value = aws_db_subnet_group.private_db.name
}