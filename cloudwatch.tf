resource "aws_cloudwatch_log_group" "atproto_pds" {
  name              = "/aws/ecs/atproto_pds"
  retention_in_days = var.ecs_log_retention_in_days
}

resource "aws_cloudwatch_log_group" "atproto_bgs" {
  name              = "/aws/ecs/atproto_bgs"
  retention_in_days = var.ecs_log_retention_in_days
}

resource "aws_cloudwatch_log_group" "meili" {
  name              = "/aws/ecs/meili"
  retention_in_days = var.ecs_log_retention_in_days
}

resource "aws_cloudwatch_log_group" "svccon-server" {
  name              = "/aws/ecs/svccon-server"
  retention_in_days = var.ecs_log_retention_in_days
}
