# Create a VPC
resource "aws_vpc" "atproto_pds" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    "Name" = "atproto_pds"
  }
}

resource "aws_subnet" "atproto_pds_public_a" {
  vpc_id            = aws_vpc.atproto_pds.id
  availability_zone = "${var.region}a"
  cidr_block        = "10.0.0.0/20"

  tags = {
    "Name" = "atproto_pds public a"
  }
}

resource "aws_subnet" "atproto_pds_public_c" {
  vpc_id            = aws_vpc.atproto_pds.id
  availability_zone = "${var.region}c"
  cidr_block        = "10.0.16.0/20"

  tags = {
    "Name" = "atproto_pds public c"
  }
}

resource "aws_subnet" "atproto_pds_public_d" {
  vpc_id            = aws_vpc.atproto_pds.id
  availability_zone = "${var.region}d"
  cidr_block        = "10.0.32.0/20"

  tags = {
    "Name" = "atproto_pds public d"
  }
}

resource "aws_internet_gateway" "atproto_pds" {
  vpc_id = aws_vpc.atproto_pds.id

  tags = {
    "Name" = "atproto_pds"
  }
}

resource "aws_route_table" "atproto_pds_public" {
  vpc_id = aws_vpc.atproto_pds.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.atproto_pds.id
  }

  tags = {
    "Name" = "atproto_pds_public"
  }
}

resource "aws_route_table_association" "atproto_pds_public_a" {
  subnet_id      = aws_subnet.atproto_pds_public_a.id
  route_table_id = aws_route_table.atproto_pds_public.id
}

resource "aws_route_table_association" "atproto_pds_public_c" {
  subnet_id      = aws_subnet.atproto_pds_public_c.id
  route_table_id = aws_route_table.atproto_pds_public.id
}

resource "aws_route_table_association" "atproto_pds_public_d" {
  subnet_id      = aws_subnet.atproto_pds_public_d.id
  route_table_id = aws_route_table.atproto_pds_public.id
}

resource "aws_vpc_endpoint" "atproto_pds_logs" {
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.atproto_pds.id
  subnet_ids = [
    aws_subnet.atproto_pds_public_a.id,
    aws_subnet.atproto_pds_public_c.id,
    aws_subnet.atproto_pds_public_d.id,
  ]

  security_group_ids  = [aws_security_group.atproto_pds_vpc-endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "atproto_pds_s3" {
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  vpc_id            = aws_vpc.atproto_pds.id
  route_table_ids   = [aws_route_table.atproto_pds_public]
}

resource "aws_vpc_endpoint" "atproto_pds_secretmanager" {
  service_name      = "com.amazonaws.${var.region}.secretmanager"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.atproto_pds.id
  subnet_ids = [
    aws_subnet.atproto_pds_public_a.id,
    aws_subnet.atproto_pds_public_c.id,
    aws_subnet.atproto_pds_public_d.id,
  ]

  security_group_ids  = [aws_security_group.atproto_pds_vpc-endpoint.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "atproto_pds_ssm" {
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.atproto_pds.id
  subnet_ids = [
    aws_subnet.atproto_pds_public_a.id,
    aws_subnet.atproto_pds_public_c.id,
    aws_subnet.atproto_pds_public_d.id,
  ]

  security_group_ids  = [aws_security_group.atproto_pds_vpc-endpoint.id]
  private_dns_enabled = true
}
