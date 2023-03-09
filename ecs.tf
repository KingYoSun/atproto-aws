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
    image = "${var.atproto_pds_container_repo_url}:${var.atproto_pds_container_tag}"
  }
}

resource "aws_ecs_task_definition" "atproto_pds" {
  family                   = "atproto_pds"
  container_definitions    = data.template_file.atproto_pds_container_definitions.rendered
  cpu                      = 1024
  memory                   = 2048
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  depends_on = [
    aws_vpc_endpoint.atproto_pds_s3,
    aws_vpc_endpoint.atproto_pds_logs,
    aws_vpc_endpoint.atproto_pds_secretmanager,
    aws_vpc_endpoint.atproto_pds_ssm,
  ]
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
  template = file("/policies/iam_role_policy/fargate-task-execution.json")

  vars = {
    "ssm_arn"           = "value",
    "secretmanager_arn" = "value",
    "s3_arn"            = "value"
  }
}

resource "aws_iam_role_policy_attachment" "atproto_pds_AmazonECSTaskExecutionRolePolicy" {
  role       = aws_iam_role.atproto_pds_fargate-task-execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
