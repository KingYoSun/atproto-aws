resource "aws_iam_user" "atproto_pds_ses_smtp" {
  name = "ATProtoPdsSesSmtpUser"
}

resource "aws_iam_user_policy" "atproto_pds_ses_smtp_user" {
  name   = "ATProtoPdsSesSmtpPolicy"
  user   = aws_iam_user.atproto_pds_ses_smtp.name
  policy = <<JSON
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Effect":"Allow",
      "Action":[
        "ses:SendEmail",
        "ses:SendRawEmail"
      ],
      "Resource":"*"
    }
  ]
}
JSON
}

resource "aws_iam_access_key" "atproto_pds_ses_smtp_key" {
  user = aws_iam_user.atproto_pds_ses_smtp.name
}

output "aws_iam_access_key" {
  value     = aws_iam_access_key.atproto_pds_ses_smtp_key.id
  sensitive = true
}

output "aws_iam_secret" {
  value     = aws_iam_access_key.atproto_pds_ses_smtp_key.secret
  sensitive = true
}

output "aws_iam_smtp_password_v4" {
  value     = aws_iam_access_key.atproto_pds_ses_smtp_key.ses_smtp_password_v4
  sensitive = true
}

resource "aws_ses_domain_identity" "atproto_pds" {
  domain = var.host_domain
}

resource "aws_ses_domain_dkim" "atproto_pds" {
  domain = var.host_domain
}

resource "aws_ses_domain_mail_from" "atproto_pds" {
  domain = var.host_domain
  mail_from_domain = "mail.${var.host_domain}"
}
