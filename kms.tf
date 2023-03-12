data "template_file" "atproto_pds_kms_key_policy" {
  template = file("./policies/kms_key_policy/admin_user_key_policy.json")

  vars = {
    "aws_account_id" = var.aws_account_id,
    "aws_region"     = var.aws_region,
    "aws_sso_role"   = var.aws_sso_role
  }
}

resource "aws_kms_key" "atproto_pds_signing_key" {
  tags = {
    "Name" = "atproto_pds_signing_key"
  }

  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  policy = data.template_file.atproto_pds_kms_key_policy.rendered
}

resource "aws_kms_alias" "atproto_pds_signing_key" {
  name          = "alias/atproto/pds/signing_key"
  target_key_id = aws_kms_key.atproto_pds_signing_key.key_id
}

resource "aws_kms_key" "atproto_pds_recovery_key" {
  tags = {
    "Name" = "atproto_pds_recovery_key"
  }

  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  policy = data.template_file.atproto_pds_kms_key_policy.rendered
}

resource "aws_kms_alias" "atproto_pds_recovery_key" {
  name          = "alias/atproto/pds/recovery_key"
  target_key_id = aws_kms_key.atproto_pds_recovery_key.key_id
}
