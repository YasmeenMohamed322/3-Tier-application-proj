resource "aws_launch_template" "this" {
  name_prefix   = var.name
  image_id      = var.ami
  instance_type = var.instance_type

  vpc_security_group_ids = var.security_groups
  
  key_name = var.key_name
  #user_data = base64encode(var.user_data)

  lifecycle {
    create_before_destroy = true
  }
  user_data = base64encode(<<-EOF
              #!/bin/bash
              # 1. Get the Instance ID from metadata
              INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
              
              # 2. Use a random suffix or the ID to make it unique
              UNIQUE_NAME="${var.name}-$${INSTANCE_ID: -4}"
              
              # 3. Tag the instance itself
              aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=$UNIQUE_NAME --region us-east-1
              
              # 4. Set the internal hostname so Ansible sees it clearly
              hostnamectl set-hostname $UNIQUE_NAME
              EOF
  )
}

resource "aws_autoscaling_group" "this" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  vpc_zone_identifier = var.subnets

  launch_template {
    id      = aws_launch_template.this.id
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
