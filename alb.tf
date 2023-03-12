resource "aws_lb" "atproto_pds" {
  name               = "ATprotoPDS"
  load_balancer_type = "application"
  security_groups = [
    aws_security_group.atproto_pds_alb.id
  ]

  subnets = [
    aws_subnet.atproto_pds_public_a.id,
    aws_subnet.atproto_pds_public_c.id,
    aws_subnet.atproto_pds_public_d.id
  ]

  access_logs {
    bucket  = aws_s3_bucket.atproto_pds_alb_log.id
    enabled = true
  }
}

resource "aws_lb_listener" "atproto_pds_https" {
  load_balancer_arn = aws_lb.atproto_pds.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.atproto_pds.arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "503 Service Temporarily Unavailable"
      status_code  = "503"
    }
  }

  depends_on = [
    aws_acm_certificate_validation.atproto_pds_a
  ]
}

resource "aws_lb_listener" "atproto_pds_http" {
  load_balancer_arn = aws_lb.atproto_pds.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
