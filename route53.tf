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

  lifecycle {
    create_before_destroy = true
  }
}