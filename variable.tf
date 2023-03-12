variable "aws_region" {
  type        = string
  description = "aws region"
  default     = "ap-northeast-1"
}

variable "aws_account_id" {
  type        = string
  description = "AWSアカウントID"
}

variable "aws_sso_role" {
  type        = string
  description = "AWSのSSO Adminロール"
}

variable "ecs_log_retention_in_days" {
  type        = number
  description = "ECSのログ保持日数"
  default     = 90
}

variable "atproto_pds_container_repo_url" {
  type        = string
  description = "PDSのコンテナのURL"
  default     = "docker.io/kingyosun/atproto"
}

variable "atproto_pds_container_tag" {
  type        = string
  description = "PDSのコンテナのタグ"
  default     = "latest"
}

variable "host_domain" {
  type        = string
  description = "PDSのドメイン"
  default     = "localhost"
}

variable "ssm_parameter_store_base" {
  type        = string
  description = "SSMパラメータの基準となるパス"
  default     = "/atproto/pds"
}

variable "database_username" {
  type        = string
  description = "DBのUSERNAME"
  default     = "admin"
}

variable "database_password" {
  type        = string
  description = "DBのPASSWORD"
  default     = "chinpokopon"
}

variable "database_name" {
  type        = string
  description = "DB名"
  default     = "atproto_pds"
}
