resource "aws_route53_zone" "atproto_pds" {
  name = var.host_domain
}

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

resource "aws_acm_certificate" "atproto_pds" {
  domain_name       = var.host_domain
  validation_method = "DNS"

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

resource "aws_acm_certificate_validation" "atproto_pds_a" {
  provider        = "aws.acm"
  certificate_arn = aws_acm_certificate.atproto_pds.arn
  validation_record_fqdns = [
    aws_route53_record.atproto_pds_a.fqdn,
  ]
}
