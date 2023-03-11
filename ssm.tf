data "aws_ssm_parameter" "atproto_pds_database_name" {
  name = "${var.ssm_parameter_store_base}/database_name"
}

data "aws_ssm_parameter" "atproto_pds_database_username" {
  name = "${var.ssm_parameter_store_base}/database_username"
}

data "aws_ssm_parameter" "atproto_pds_database_password" {
  name = "${var.ssm_parameter_store_base}/database_password"
}
