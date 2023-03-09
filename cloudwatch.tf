resource "aws_cloudwatch_log_group" "atproto_pds" {
  name              = "/aws/ecs/atproto_pds"
  retention_in_days = var.ecs_log_retention_in_days
}