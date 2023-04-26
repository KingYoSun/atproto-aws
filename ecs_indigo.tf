resource "aws_ecs_cluster" "atproto_bgs" {
  name = "atproto_bgs"
  tags = {
    "Name" = "atproto-bgs"
  }
}

resource "aws_ecs_cluster_capacity_providers" "atproto_bgs" {
  cluster_name       = aws_ecs_cluster.atproto_bgs.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

data "template_file" "atproto_bgs_container_definitions" {
  template = file("./container_definitions/bgs.json")

  vars = {
    image                  = "${var.atproto_bgs_container_repo_url}:${var.atproto_bgs_container_tag}",
    aws_region             = var.aws_region
    cloudwatch_group_name  = aws_cloudwatch_log_group.atproto_bgs.name
    admin_password_arn     = aws_ssm_parameter.atproto_bgs_admin_password.arn,
    meilisearch_apikey_arn = aws_ssm_parameter.meilisearch_apikey.arn,
    database_url           = "postgres://${var.database_username}:${var.database_password}@${aws_rds_cluster.atproto_pds.endpoint}:5432/bgs"
    carstore_database_url  = "postgres://${var.database_username}:${var.database_password}@${aws_rds_cluster.atproto_pds.endpoint}:5432/carstore"
    meilisearch_url        = "http://meilisearch.atproto:7700"
    atp_plc_host           = var.did_plc_server_url,
  }
}

resource "aws_ecs_task_definition" "atproto_bgs" {
  family                   = "atproto_bgs"
  container_definitions    = data.template_file.atproto_bgs_container_definitions.rendered
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.atproto_bgs_fargate-task-execution.arn
  task_role_arn            = aws_iam_role.atproto_bgs_fargate-task.arn

  volume {
    name = "data"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.atproto_bgs.id
      root_directory = "/data/bigsky"
    }
  }
}


resource "aws_iam_role" "atproto_bgs_fargate-task" {
  name               = "atproto_bgs_fargate-task"
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
    "Name" = "atproto_bgs_fargate-task"
  }
}


resource "aws_ecs_service" "atproto_bgs" {
  name                               = "atproto_bgs"
  cluster                            = aws_ecs_cluster.atproto_bgs.id
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.atproto_bgs.arn
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
      aws_security_group.atproto_bgs_app.id,
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.atproto_bgs.arn
    container_name   = "atproto_bgs"
    container_port   = 2470
  }

  service_connect_configuration {
    enabled = true

    log_configuration {
      log_driver = "awslogs"
      options = {
        "awslogs-region" : var.aws_region,
        "awslogs-stream-prefix" : "svccon-client",
        "awslogs-group" : aws_cloudwatch_log_group.svccon-server.name
      }
    }

    namespace = aws_service_discovery_http_namespace.atproto.arn
  }

  depends_on = [
    aws_lb_target_group.atproto_bgs
  ]
}

resource "aws_lb_target_group" "atproto_bgs" {
  # name                 = "ATprotobgs"
  name_prefix          = "bgs-"
  vpc_id               = aws_vpc.atproto_pds.id
  target_type          = "ip"
  port                 = 2470
  protocol             = "HTTP"
  deregistration_delay = 300
  health_check {
    path     = "/xrpc/_health"
    interval = 60
    timeout  = 30
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "atproto_bgs" {
  listener_arn = aws_lb_listener.atproto_pds_https.arn
  priority     = 3
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atproto_bgs.arn
  }
  condition {
    host_header {
      values = ["big.${var.host_domain}"]
    }
  }
}


resource "aws_iam_role_policy" "atproto_bgs_fargate-task" {
  name   = "atproto_bgs_fargate-task"
  role   = aws_iam_role.atproto_bgs_fargate-task.name
  policy = data.template_file.atproto_bgs_fargate-task.rendered
}

data "template_file" "atproto_bgs_fargate-task" {
  template = file("./policies/iam_role_policy/fargate-task-bgs.json")
}

resource "aws_iam_role" "atproto_bgs_fargate-task-execution" {
  name               = "atproto_bgs_fargate-task-execution"
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
    "Name" = "atproto_bgs_fargate-task-execution"
  }
}

resource "aws_iam_role_policy" "atproto_bgs_fargate-task-execution" {
  name   = "atproto_bgs_fargate-task-execution"
  role   = aws_iam_role.atproto_bgs_fargate-task-execution.name
  policy = data.template_file.atproto_bgs_fargate-task-execution.rendered
}

data "template_file" "atproto_bgs_fargate-task-execution" {
  template = file("./policies/iam_role_policy/fargate-task-execution-bgs.json")

  vars = {
    "ssm_arn"                   = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.ssm_parameter_store_base}",
    "ssm_database_password_arn" = aws_ssm_parameter.atproto_pds_database_password.arn
  }
}

resource "aws_iam_role_policy_attachment" "atproto_bgs_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.atproto_bgs_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "atproto_bgs_AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.atproto_bgs_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

#############################################
### EFS
#############################################

resource "aws_efs_file_system" "atproto_bgs" {
  tags = {
    Name = "atproto_bgs-efs"
  }
}

resource "aws_efs_mount_target" "atproto_bgs_1a" {
  file_system_id  = aws_efs_file_system.atproto_bgs.id
  subnet_id       = aws_subnet.atproto_pds_public_a.id
  security_groups = [aws_security_group.efs_bgs.id]
}

############################
### Service Discovery
############################

resource "aws_service_discovery_http_namespace" "atproto" {
  name = "atproto"
}