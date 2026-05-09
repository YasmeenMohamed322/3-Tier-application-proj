resource "aws_launch_template" "launche_template" {
  name_prefix   = var.name
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups
  
  key_name = var.key_name
  #user_data = base64encode(var.user_data)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ASG" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.launche_template.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
}
