resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet
  vpc_security_group_ids      = [var.bastion_sg]
  key_name                    = var.key_name

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
    Role = "bastion"
  }
}