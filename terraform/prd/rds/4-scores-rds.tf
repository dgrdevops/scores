locals {
  db_username               = "devopsadmin"
  backup_retention_period   = 10
  preferred_backup_window   = "05:00-07:00"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.1"
  db_cluster_instance_class = "db.t4g.medium"
}

resource "random_password" "db_password" {
  length           = 24
  min_lower        = 1
  min_numeric      = 3
  min_special      = 3
  min_upper        = 3
  special          = true
  numeric          = true
  upper            = true
  override_special = "!#$&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.env}-${var.application}-access"
  description = "Devops DB access credentials for ${var.env} environment."
  tags = {
    "Name" = "${var.env}-${var.application}-access"
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    USERNAME = local.db_username
    PASSWORD = random_password.db_password.result
  })
}

resource "aws_rds_cluster_parameter_group" "mysql_pg" {
  name        = "${var.env}-${var.application}-mysql-pg"
  family      = "aurora-mysql8.0"
  description = "${var.env}-${var.application} cluster parameter group"
}

resource "aws_rds_cluster_instance" "rds_instances" {
  count              = 1
  identifier         = "${var.env}-${var.application}-${count.index}"
  cluster_identifier = aws_rds_cluster.database.id
  instance_class     = local.db_cluster_instance_class
  engine             = aws_rds_cluster.database.engine
  engine_version     = aws_rds_cluster.database.engine_version
}

resource "aws_rds_cluster" "database" {
  cluster_identifier              = "${var.env}-${var.application}"
  db_subnet_group_name            = aws_db_subnet_group.private_db.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.mysql_pg.name
  vpc_security_group_ids          = [aws_security_group.db_sg.id]
  master_username                 = local.db_username
  master_password                 = random_password.db_password.result
  backup_retention_period         = local.backup_retention_period
  preferred_backup_window         = local.preferred_backup_window
  engine                          = local.engine
  engine_version                  = local.engine_version
  skip_final_snapshot             = true
  deletion_protection             = true
  copy_tags_to_snapshot           = true
  storage_encrypted               = true

  lifecycle {
    ignore_changes = [
      engine_version,
      availability_zones,
      master_username,
      master_password,
    ]
  }

  tags = {
    Name = "${var.env}-${var.application}"
  }
}