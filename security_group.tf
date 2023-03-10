resource "aws_security_group" "atproto_pds_app" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_pds_app"

  tags = {
    "Name" = "atproto_pds_app"
  }
}

resource "aws_security_group_rule" "atproto_pds_app_from_self" {
  security_group_id = aws_security_group.atproto_pds_app.id
  type = "ingress"
  description = "Allow from Self"
  from_port = 0
  to_port = 0
  protocol = "-1"
  self = true
}

resource "aws_security_group_rule" "atproto_pds_app_from_alb" {
  security_group_id = aws_security_group.atproto_pds_app.id
  type = "ingress"
  description = "Allow from ALB"
  from_port = 0
  to_port = 0
  protocol = "-1"
  source_security_group_id = aws_security_group.atproto_pds_alb.id
}

resource "aws_security_group_rule" "atproto_pds_app_from_any" {
  security_group_id = aws_security_group.atproto_pds_app.id
  type = "egress"
  description = "Allow to Any"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "atproto_pds_alb" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_pds_alb"

  egress = [ {
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "allow all"
    from_port = 0
    ipv6_cidr_blocks = []
    prefix_list_ids = []
    protocol = "-1"
    security_groups = []
    self = false
    to_port = 0
  } ]

  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "allow http"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0"]
      description      = "allow https"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    },
  ]

  tags = {
    "Name" = "atproto_pds_alb"
  }
}

resource "aws_security_group" "atproto_pds_vpc-endpoint" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_pds_vpc-endpoint"

  egress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow all"
    from_port        = 0
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "-1"
    security_groups  = []
    self             = false
    to_port          = 0
  }]

  ingress = [{
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "private link"
    from_port        = 443
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 443
  }]

  tags = {
    "Name" = "atproto_pds_vpc-enddpoint"
  }
}
