resource "aws_db_subnet_group" "atproto_pds" {
  name = "atproto_pds"

  subnet_ids = [
    aws_subnet.atproto_pds_private_a.id,
    aws_subnet.atproto_pds_private_c.id,
    aws_subnet.atproto_pds_private_d.id
  ]
}

resource "aws_rds_cluster" "atproto_pds" {
  cluster_identifier = "atproto-pds"

  db_subnet_group_name   = aws_db_subnet_group.atproto_pds.name
  vpc_security_group_ids = [aws_security_group.atproto_pds_db.id]

  engine         = "aurora-postgresql"
  engine_version = "14.6"
  port           = "5432"

  database_name   = var.database_name
  master_username = var.database_username
  master_password = var.database_password

  skip_final_snapshot = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.atproto_pds.name
}

resource "aws_rds_cluster_parameter_group" "atproto_pds" {
  name   = "atproto-pds"
  family = "aurora-postgresql14"

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }
}

resource "aws_rds_cluster_instance" "atproto_pds" {
  identifier         = "atproto-pds-instance"
  cluster_identifier = aws_rds_cluster.atproto_pds.id

  engine         = aws_rds_cluster.atproto_pds.engine
  engine_version = aws_rds_cluster.atproto_pds.engine_version

  instance_class          = "db.t4g.medium"
  db_subnet_group_name    = aws_rds_cluster.atproto_pds.db_subnet_group_name
  db_parameter_group_name = aws_rds_cluster_parameter_group.atproto_pds.name
}
