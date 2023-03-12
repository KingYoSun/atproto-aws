resource "aws_ecs_cluster" "atproto_pds" {
  name = "atproto_pds"
  tags = {
    "Name" = "atproto-pds"
  }
}

resource "aws_ecs_cluster_capacity_providers" "atproto_pds" {
  cluster_name       = aws_ecs_cluster.atproto_pds.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

data "template_file" "atproto_pds_container_definitions" {
  template = file("container_definitions.json")

  vars = {
    image                  = "${var.atproto_pds_container_repo_url}:${var.atproto_pds_container_tag}",
    aws_region             = var.aws_region
    cloudwatch_group_name  = aws_cloudwatch_log_group.atproto_pds.name
    database_name          = var.database_name
    database_username      = var.database_username
    database_host          = aws_rds_cluster.atproto_pds.endpoint
    database_password      = var.database_password
    signing_key_id         = aws_kms_key.atproto_pds_signing_key.key_id
    recovery_key_id        = aws_kms_key.atproto_pds_recovery_key.key_id
    s3_bucket_name         = var.s3_bucket_name
    cf_distribution_id     = aws_cloudfront_distribution.atproto_pds.id
    pds_version            = var.pds_version
    hostname               = var.host_domain
    jwt_secret_arn         = aws_ssm_parameter.atproto_pds_jwt_secret.arn
    admin_password_arn     = aws_ssm_parameter.atproto_pds_admin_password.arn
    invite_required        = var.invite_required
    available_user_domains = var.available_user_domains
    smtp_host              = ""
    smtp_username          = ""
    smtp_password          = ""
    email_smtp_url         = ""
    email_no_reply_address = ""
    did_plc_url            = ""
    log_level              = var.log_level
  }
}

resource "aws_ecs_task_definition" "atproto_pds" {
  family                   = "atproto_pds"
  container_definitions    = data.template_file.atproto_pds_container_definitions.rendered
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.atproto_pds_fargate-task-execution.arn
  task_role_arn            = aws_iam_role.atproto_pds_fargate-task.arn

  depends_on = [
    aws_vpc_endpoint.atproto_pds_s3,
    aws_vpc_endpoint.atproto_pds_logs,
    aws_vpc_endpoint.atproto_pds_ssm,
  ]
}

resource "aws_ecs_service" "atproto_pds" {
  name                               = "atproto_pds"
  cluster                            = aws_ecs_cluster.atproto_pds.id
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.atproto_pds.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  propagate_tags                     = "SERVICE"
  enable_execute_command             = true
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 60

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    assign_public_ip = true
    subnets = [
      aws_subnet.atproto_pds_public_a.id,
    ]
    security_groups = [
      aws_security_group.atproto_pds_app.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.atproto_pds.arn
    container_name   = "atproto_pds"
    container_port   = 2583
  }
}

resource "aws_lb_target_group" "atproto_pds" {
  name                 = "ATprotoPDS"
  vpc_id               = aws_vpc.atproto_pds.id
  target_type          = "ip"
  port                 = 80
  protocol             = "HTTP"
  deregistration_delay = 60
  health_check { path = "/api/health_check" }
}

resource "aws_lb_listener_rule" "atproto_pds" {
  listener_arn = aws_lb_listener.atproto_pds_https.arn
  priority     = 2
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atproto_pds.arn
  }
  condition {
    host_header {
      values = [var.host_domain]
    }
  }
}

resource "aws_iam_role" "atproto_pds_fargate-task" {
  name               = "atproto_pds_fargate-task"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF

  tags = {
    "Name" = "atproto_pds_fargate-task"
  }
}

resource "aws_iam_role" "atproto_pds_fargate-task-execution" {
  name               = "atproto_pds_fargate-task-execution"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
  EOF

  tags = {
    "Name" = "atproto_pds_fargate-task-execution"
  }
}

resource "aws_iam_role_policy" "atproto_pds_fargate-task-execution" {
  name   = "atproto_pds_fargate-task-execution"
  role   = aws_iam_role.atproto_pds_fargate-task-execution.name
  policy = data.template_file.atproto_pds_fargate-task-execution.rendered
}

data "template_file" "atproto_pds_fargate-task-execution" {
  template = file("./policies/iam_role_policy/fargate-task-execution.json")

  vars = {
    "ssm_arn"                   = var.ssm_parameter_store_base,
    "s3_arn"                    = aws_s3_bucket.atproto_pds.arn,
    "ssm_database_password_arn" = var.database_password
  }
}

resource "aws_iam_role_policy_attachment" "atproto_pds_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.atproto_pds_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "atproto_pds_AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.atproto_pds_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}
