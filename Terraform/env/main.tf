resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-key"
  public_key = file(var.public_key_path)
}
module "frontend_ec2" {
  source = "../modules/ec2"

  name              = "frontend"
  ami               = var.ami
  instance_type     = "t2.micro"

  key_name = aws_key_pair.ansible_key.key_name
  
  subnets           = var.public_subnets
  security_groups   = [var.frontend_sg]

  desired_capacity  = 2
  min_size          = 1
  max_size          = 3

  target_group_arns = [module.frontend_alb.target_group_arn]

  
}

module "backend_ec2" {
  source = "../modules/ec2"

  name              = "backend"
  ami               = var.ami
  instance_type     = "t2.micro"

  key_name = aws_key_pair.ansible_key.key_name

  subnets           = var.private_subnets
  security_groups   = [var.backend_sg]

  desired_capacity  = 2
  min_size          = 1
  max_size          = 3

  target_group_arns = [module.backend_alb.target_group_arn]

  
}

module "frontend_alb" {
  source = "../modules/alb"

  name            = "frontend-alb"
  internal        = false

  subnets         = var.public_subnets
  security_groups = [var.frontend_alb_sg]
  vpc_id          = var.vpc_id

  port             = 80
  listener_port    = 80
  health_check_path = "/"
}

module "backend_alb" {
  source = "../modules/alb"

  name            = "backend-alb"
  internal        = true

  subnets         = var.private_subnets
  security_groups = [var.backend_alb_sg]
  vpc_id          = var.vpc_id

  port             = 5000
  listener_port    = 80
  health_check_path = "/health"
}

module "bastion" {
  source = "../modules/bastion"

  ami            = var.ami
  instance_type  = "t2.micro"

  public_subnet  = var.public_subnets[0]
  bastion_sg     = var.frontend_alb_sg
  key_name       = aws_key_pair.ansible_key.key_name
}