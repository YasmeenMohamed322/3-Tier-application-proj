##The load balancer 
resource "aws_lb" "lb" {
  name               = var.name
  internal           = var.internal
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = var.security_groups

  tags = { 
    Name = var.name 
    }
}


##Target groups
resource "aws_lb_target_group" "lb_target_gp" {
  name     = var.name
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }
}


##Listner 
resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.this.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}