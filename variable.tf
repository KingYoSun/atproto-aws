variable "pds_version" {
  type        = string
  description = "PDSコンテナのversion"
  default     = "0.0.0"
}

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

variable "kms_signing_key_alias" {
  type        = string
  description = "KMSのsigning_keyのalias"
  default     = "alias/atproto/pds/signing_key"
}

variable "kms_recovery_key_alias" {
  type        = string
  description = "KMSのrecovery_keyのalias"
  default     = "alias/atproto/pds/recovery_key"
}

variable "s3_bucket_name" {
  type        = string
  description = "S3のバケット名"
  default     = "atproto-pds"
}

variable "s3_bucket_name_bgs" {
  type        = string
  description = "S3のバケット名(bgs)"
  default     = "atproto-bgs"
}

variable "jwt_secret" {
  type        = string
  description = ""
}

variable "admin_password" {
  type        = string
  description = "管理者パスワード"
}

variable "invite_required" {
  type        = string
  description = "招待コードが必要な場合true"
  default     = "true"
}

variable "user_invite_interval" {
  type        = number
  description = "ユーザーの招待コード発行間隔(一週間)"
  default     = 604800000
}

variable "available_user_domains" {
  type        = string
  description = ",区切りで複数定義できる, ユーザーが利用可能なドメイン"
  default     = ".test,.dev.bsky.dev"
}

variable "log_level" {
  type        = string
  description = "Log Level"
  default     = "info"
}

variable "server_did" {
  type        = string
  description = "鯖缶Did? 事前にplcサーバーで作成する"
}

variable "did_plc_server_url" {
  type        = string
  description = "PLCサーバーのURL"
  default     = "https://plc.directory"
}

variable "ses_smtp_key_id" {
  type        = string
  description = "SMTPサーバーのAccess Key"
}

variable "ses_smtp_password_v4" {
  type        = string
  description = "SMTPサーバーのPassword v4"
}

variable "repo_signing_key" {
  type        = string
  description = "repository signing key(raw)"
}

variable "hive_api_key" {
  type        = string
  description = "key of HiveLabeler"
}

variable "labeler_did" {
  type        = string
  description = "did of HiveLabeler"
}

variable "moderator_password" {
  type        = string
  description = "password of moderator"
}