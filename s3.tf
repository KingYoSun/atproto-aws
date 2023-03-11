resource "aws_s3_bucket" "atproto_pds" {
  bucket = "atproto-pds"

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
