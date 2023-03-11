resource "aws_cloudfront_distribution" "atproto_pds" {
  enabled = true
  aliases = [var.host_domain]

  origin {
    domain_name = aws_lb.atproto_pds.dns_name
    origin_id   = aws_lb.atproto_pds.dns_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "match-viewer"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"]
    cached_methods         = []
    compress               = false
    default_ttl            = 0
    max_ttl                = 0
    min_ttl                = 0
    smooth_streaming       = false
    target_origin_id       = aws_lb.atproto_pds.dns_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    allowed_methods        = ["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = false
    default_ttl            = "86400"
    max_ttl                = "31536000"
    min_ttl                = "0"
    smooth_streaming       = false
    path_pattern           = "/image/*"
    target_origin_id       = aws_lb.atproto_pds.dns_name
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true
      headers      = ["*"]
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.atproto_pds.arn
  }

  tags = {
    "Name" = "atproto_pds"
  }
}
