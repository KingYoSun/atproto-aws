############################
### PDS
############################

resource "aws_security_group" "atproto_pds_app" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_pds_app"

  tags = {
    "Name" = "atproto_pds_app"
  }
}

resource "aws_security_group_rule" "atproto_pds_app_from_self" {
  security_group_id = aws_security_group.atproto_pds_app.id
  type              = "ingress"
  description       = "Allow from Self"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "atproto_pds_app_from_alb" {
  security_group_id        = aws_security_group.atproto_pds_app.id
  type                     = "ingress"
  description              = "Allow from ALB"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.atproto_pds_alb.id
}

resource "aws_security_group_rule" "atproto_pds_app_from_any" {
  security_group_id = aws_security_group.atproto_pds_app.id
  type              = "egress"
  description       = "Allow to Any"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

############################
### BGS
############################

resource "aws_security_group" "atproto_bgs_app" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_bgs_app"

  tags = {
    "Name" = "atproto_bgs_app"
  }
}

resource "aws_security_group_rule" "atproto_bgs_app_from_self" {
  security_group_id = aws_security_group.atproto_bgs_app.id
  type              = "ingress"
  description       = "Allow from Self"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "atproto_bgs_app_from_alb" {
  security_group_id        = aws_security_group.atproto_bgs_app.id
  type                     = "ingress"
  description              = "Allow from ALB"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.atproto_pds_alb.id
}

resource "aws_security_group_rule" "atproto_bgs_app_from_any" {
  security_group_id = aws_security_group.atproto_bgs_app.id
  type              = "egress"
  description       = "Allow to Any"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

############################
### Meili
############################

resource "aws_security_group" "meili_app" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "meili_app"

  tags = {
    "Name" = "meili_app"
  }
}

resource "aws_security_group_rule" "meili_app_from_self" {
  security_group_id = aws_security_group.meili_app.id
  type              = "ingress"
  description       = "Allow from Self"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
}

resource "aws_security_group_rule" "meili_app_from_bgs" {
  security_group_id        = aws_security_group.meili_app.id
  type                     = "ingress"
  description              = "Allow from BGS"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.atproto_bgs_app.id
}

resource "aws_security_group_rule" "meili_app_from_any" {
  security_group_id = aws_security_group.meili_app.id
  type              = "egress"
  description       = "Allow to Any"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

############################
### ALB
############################

resource "aws_security_group" "atproto_pds_alb" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_pds_alb"

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

############################
### DB
############################

resource "aws_security_group" "atproto_pds_db" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "atproto_pds_db"

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

  tags = {
    "Name" = "atproto_pds_db"
  }
}

resource "aws_security_group_rule" "atproto_pds_db_from_app" {
  security_group_id        = aws_security_group.atproto_pds_db.id
  type                     = "ingress"
  description              = "Allow from App"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.atproto_pds_app.id
}

resource "aws_security_group_rule" "atproto_pds_db_from_bastion" {
  security_group_id        = aws_security_group.atproto_pds_db.id
  type                     = "ingress"
  description              = "Allow from Bastion"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.bastion.id
}

############################
### Bastion
############################

resource "aws_security_group" "bastion" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "bastion"

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
    description      = "allow all"
    from_port        = 22
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    protocol         = "tcp"
    security_groups  = []
    self             = false
    to_port          = 22
  }]

  tags = {
    "Name" = "bastion"
  }
}

############################
### EFS
############################

resource "aws_security_group" "efs_bgs" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "efs_bgs"

  ingress = [{
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.atproto_bgs_app.id]
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow BGS"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }]

  egress = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow all"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }]

  tags = {
    "Name" = "efs_bgs"
  }
}

resource "aws_security_group" "efs_meili" {
  vpc_id = aws_vpc.atproto_pds.id
  name   = "efs_meili"

  ingress = [{
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.meili_app.id]
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow meili"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }]

  egress = [{
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    description      = "allow meili"
    security_groups  = []
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    self             = false
  }]

  tags = {
    "Name" = "efs_meili"
  }
}
