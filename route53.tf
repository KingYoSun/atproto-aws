resource "aws_route53_zone" "atproto_pds" {
  name = var.host_domain
}

/*
resource "aws_route53_record" "atproto_pds" {
  name    = aws_route53_zone.atproto_pds.name
  type    = "NS"
  zone_id = aws_route53_zone.atproto_pds.zone_id
  records = [
    aws_route53_zone.atproto_pds.name_servers[0],
    aws_route53_zone.atproto_pds.name_servers[1],
    aws_route53_zone.atproto_pds.name_servers[2],
    aws_route53_zone.atproto_pds.name_servers[3]
  ]

  ttl = 172800
}
*/

#############################################################
# For BGS Subdomain
#############################################################

resource "aws_route53_zone" "atproto_bgs"  {
  name = "big.${var.host_domain}"
}

resource "aws_route53_record" "ns_records_for_atproto_bgs" {
  name    = aws_route53_zone.atproto_pds.name
  type    = "NS"
  zone_id = data.aws_route53_zone.atproto_pds.id
  records = [
    aws_route53_zone.atproto_bgs.name_servers[0],
    aws_route53_zone.atproto_bgs.name_servers[1],
    aws_route53_zone.atproto_bgs.name_servers[2],
    aws_route53_zone.atproto_bgs.name_servers[3]
  ]

  ttl  = 300
}

resource "aws_route53_record" "a_records_for_atproto_bgs" {
  zone_id = aws_route53_zone.atproto_bgs.zone_id
  name    = aws_route53_zone.atproto_bgs.name
  type    = "A"

  # information for ALB
  alias {
    name                   = aws_lb.atproto_pds.dns_name
    zone_id                = aws_lb.atproto_pds.zone_id
    evaluate_target_health = true
  }
}

#############################################################
# For ALB Certification
#############################################################
resource "aws_acm_certificate" "atproto_pds" {
  domain_name       = var.host_domain
  validation_method = "DNS"

  subject_alternative_names = ["*.${var.host_domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "atproto_pds_cert_validation" {
  zone_id = aws_route53_zone.atproto_pds.zone_id
  ttl     = 60

  for_each = {
    for dvo in aws_acm_certificate.atproto_pds.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  depends_on = [
    aws_acm_certificate.atproto_pds
  ]

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "atproto_pds" {
  certificate_arn = aws_acm_certificate.atproto_pds.arn
  validation_record_fqdns = [
    for record in aws_route53_record.atproto_pds_cert_validation : record.fqdn
  ]
}

#############################################################
# For SMTP
#############################################################
resource "aws_route53_record" "atproto_pds_txt" {
  name    = "_amazonses.${var.host_domain}"
  type    = "TXT"
  zone_id = aws_route53_zone.atproto_pds.zone_id
  ttl     = "600"
  records = [aws_ses_domain_identity.atproto_pds.verification_token]
}

resource "aws_route53_record" "atproto_pds_cname_dkim" {
  count   = 3
  zone_id = aws_route53_zone.atproto_pds.zone_id
  name    = "${element(aws_ses_domain_dkim.atproto_pds.dkim_tokens, count.index)}._domainkey.${var.host_domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.atproto_pds.dkim_tokens, count.index)}.dkim.amazonses.com"]
}

resource "aws_route53_record" "atproto_pds_mx_mail" {
  zone_id = aws_route53_zone.atproto_pds.zone_id
  name    = aws_ses_domain_mail_from.atproto_pds.mail_from_domain
  type    = "MX"
  ttl     = "600"
  records = ["10 feedback-smtp.ap-northeast-1.amazonses.com"]
}

resource "aws_route53_record" "atproto_pds_txt_mail" {
  zone_id = aws_route53_zone.atproto_pds.zone_id
  name    = aws_ses_domain_mail_from.atproto_pds.mail_from_domain
  type    = "TXT"
  ttl     = "600"
  records = ["v=spf1 include:amazonses.com ~all"]
}

resource "aws_route53_record" "atproto_pds_txt_dmarc" {
  zone_id = aws_route53_zone.atproto_pds.zone_id
  name    = "_dmarc.example.com"
  type    = "TXT"
  ttl     = "600"
  records = ["v=DMARC1;p=quarantine;pct=25;rua=mailto:dmarcreports@${var.host_domain}"]
}

#############################################################
# For Cloudfront Certification
#############################################################
resource "aws_acm_certificate" "atproto_pds_cloudfront" {
  domain_name       = var.host_domain
  validation_method = "DNS"
  provider          = aws.virginia

  subject_alternative_names = ["*.${var.host_domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "atproto_pds_a" {
  name    = var.host_domain
  type    = "A"
  zone_id = aws_route53_zone.atproto_pds.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.atproto_pds.domain_name
    zone_id                = aws_cloudfront_distribution.atproto_pds.hosted_zone_id
  }
}

resource "aws_route53_record" "atproto_pds_cloudfront_cert_validation" {
  zone_id = aws_route53_zone.atproto_pds.zone_id
  ttl     = 60

  for_each = {
    for dvo in aws_acm_certificate.atproto_pds_cloudfront.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  depends_on = [
    aws_acm_certificate.atproto_pds_cloudfront
  ]

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
}

resource "aws_acm_certificate_validation" "atproto_pds_a" {
  certificate_arn = aws_acm_certificate.atproto_pds_cloudfront.arn
  validation_record_fqdns = [
    for record in aws_route53_record.atproto_pds_cloudfront_cert_validation : record.fqdn
  ]
  provider = aws.virginia
}
