resource "aws_ecs_cluster" "meili" {
  name = "meili"
  tags = {
    "Name" = "meili"
  }
}

resource "aws_ecs_cluster_capacity_providers" "meili" {
  cluster_name       = aws_ecs_cluster.meili.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = 1
  }
}

data "template_file" "meili_container_definitions" {
  template = file("./container_definitions/meilisearch.json")

  vars = {
    image                 = "getmeili/meilisearch:v1.1",
    aws_region            = var.aws_region
    cloudwatch_group_name = aws_cloudwatch_log_group.meili.name
    meili_master_key_arn  = aws_ssm_parameter.meilisearch_apikey.arn,
  }
}

resource "aws_ecs_task_definition" "meili" {
  family                   = "meili"
  container_definitions    = data.template_file.meili_container_definitions.rendered
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.meili_fargate-task-execution.arn
  task_role_arn            = aws_iam_role.meili_fargate-task.arn

  volume {
    name = "meili_data"

    efs_volume_configuration {
      file_system_id = aws_efs_file_system.meili.id
      root_directory = "/meili_data"
    }
  }
}


resource "aws_iam_role" "meili_fargate-task" {
  name               = "meili_fargate-task"
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
    "Name" = "meili_fargate-task"
  }
}


resource "aws_ecs_service" "meili" {
  name                               = "meili"
  cluster                            = aws_ecs_cluster.meili.id
  platform_version                   = "LATEST"
  task_definition                    = aws_ecs_task_definition.meili.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  propagate_tags                     = "SERVICE"
  enable_execute_command             = true
  launch_type                        = "FARGATE"

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    assign_public_ip = false
    subnets = [
      aws_subnet.atproto_pds_public_a.id,
    ]
    security_groups = [
      aws_security_group.meili_app.id,
    ]
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

    service {
      client_alias {
        port = 7700
      }
      port_name = "meilisearch"
    }
  }
}


resource "aws_iam_role_policy" "meili_fargate-task" {
  name   = "meili_fargate-task"
  role   = aws_iam_role.meili_fargate-task.name
  policy = data.template_file.meili_fargate-task.rendered
}

data "template_file" "meili_fargate-task" {
  template = file("./policies/iam_role_policy/fargate-task-meili.json")
}

resource "aws_iam_role" "meili_fargate-task-execution" {
  name               = "meili_fargate-task-execution"
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
    "Name" = "meili_fargate-task-execution"
  }
}

resource "aws_iam_role_policy" "meili_fargate-task-execution" {
  name   = "meili_fargate-task-execution"
  role   = aws_iam_role.meili_fargate-task-execution.name
  policy = data.template_file.meili_fargate-task-execution.rendered
}

data "template_file" "meili_fargate-task-execution" {
  template = file("./policies/iam_role_policy/fargate-task-execution-meili.json")

  vars = {
    "ssm_arn" = "arn:aws:ssm:${var.aws_region}:${var.aws_account_id}:parameter/${var.ssm_parameter_store_base}"
  }
}

resource "aws_iam_role_policy_attachment" "meili_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.meili_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "meili_AmazonSSMReadOnlyAccess" {
  role       = aws_iam_role.meili_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

#############################################
### EFS
#############################################

resource "aws_efs_file_system" "meili" {
  tags = {
    Name = "meili-efs"
  }
}

resource "aws_efs_mount_target" "meili_1a" {
  file_system_id  = aws_efs_file_system.meili.id
  subnet_id       = aws_subnet.atproto_pds_public_a.id
  security_groups = [aws_security_group.efs_meili.id]
}
