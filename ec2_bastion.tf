resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = var.bastion_pub_key
}

resource "aws_instance" "bastion" {
  # Amazon Linux 2 AMI (HVM), SSD Volume Type
  ami                         = "ami-e99f4896"
  instance_type               = "t2.micro"
  associate_public_ip_address = "true"
  key_name                    = aws_key_pair.bastion.key_name
  subnet_id                   = aws_subnet.atproto_pds_public_a.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]

  root_block_device {
    volume_type           = "standard"
    volume_size           = "50"
    delete_on_termination = "false"
  }
}

resource "aws_eip" "default" {
  instance = aws_instance.bastion.id
  vpc      = true
}
