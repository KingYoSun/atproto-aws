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

resource "aws_ssm_parameter" "atproto_pds_jwt_secret" {
  name  = "${var.ssm_parameter_store_base}/jwt_secret"
  type  = "SecureString"
  value = var.jwt_secret
}

resource "aws_ssm_parameter" "atproto_pds_admin_password" {
  name  = "${var.ssm_parameter_store_base}/admin_password"
  type  = "SecureString"
  value = var.admin_password
}
