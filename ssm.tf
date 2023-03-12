resource "aws_ssm_parameter" "atproto_pds_database_name" {
  name  = "${var.ssm_parameter_store_base}/database_name"
  type  = "String"
  value = var.database_name
}

resource "aws_ssm_parameter" "atproto_pds_database_password" {
  name  = "${var.ssm_parameter_store_base}/database_password"
  type  = "SecureString"
  value = var.database_password
}

resource "aws_ssm_parameter" "atproto_pds_database_username" {
  name  = "${var.ssm_parameter_store_base}/database_username"
  type  = "String"
  value = var.database_username
}

resource "aws_ssm_parameter" "atproto_pds_database_url" {
  name  = "${var.ssm_parameter_store_base}/database_url"
  type  = "String"
  value = aws_rds_cluster.atproto_pds.endpoint
}
