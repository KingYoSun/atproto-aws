#################################################################
# PDS main bucket
#################################################################

resource "aws_s3_bucket" "atproto_pds" {
  bucket = var.s3_bucket_name

  tags = {
    "Name" = "atproto_pds"
  }
}

resource "aws_s3_bucket_acl" "atproto_pds" {
  bucket = aws_s3_bucket.atproto_pds.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "atproto_pds" {
  bucket                  = aws_s3_bucket.atproto_pds.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "static" {
  bucket = aws_s3_bucket.atproto_pds.id

  versioning_configuration {
    status = "Enabled"
  }
}

#################################################################
# ALB Log
#################################################################
resource "aws_s3_bucket" "atproto_pds_alb_log" {
  bucket = "${var.s3_bucket_name}-alb"

  tags = {
    "Name" = "atproto_pds_alb"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "atproto_pds_alb_log" {
  bucket = aws_s3_bucket.atproto_pds_alb_log.id

  rule {
    id     = "log"
    status = "Enabled"

    expiration {
      days = 90
    }

    filter {
      and {
        prefix = "log/"

        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_policy" "atproto_pds_alb_log" {
  bucket = aws_s3_bucket.atproto_pds_alb_log.id
  policy = data.aws_iam_policy_document.atproto_pds_alb_log.json
}

data "aws_iam_policy_document" "atproto_pds_alb_log" {
  statement {
    effect = "Allow"
    principals {
      type = "AWS"
      # 東京のALB AWS ACCOUNT ID
      identifiers = [
        "arn:aws:iam::582318560864:root"
      ]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.s3_bucket_name}-alb/log/AWSLogs/${var.aws_account_id}/*"]
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.atproto_pds_alb_log.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }

  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = [aws_s3_bucket.atproto_pds_alb_log.arn]
  }
}