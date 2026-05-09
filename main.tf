 ##SSH key for ansible 
 resource "aws_key_pair" "ansible_key" {
  key_name   = "ansible-key"
  public_key = file(var.public_key_path)
}

## Networking layer
module "network" {
  source = "./modules/vpc"

  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
}

## Compute
module "frontend_ec2" {
  source = "./modules/ec2"

  name              = "frontend"
  ami               = var.ami
  instance_type     = "t3.micro"

  key_name = aws_key_pair.ansible_key.key_name
  
  subnets           = module.network.public_subnets
  security_groups   = [module.network.frontend_sg]

  desired_capacity  = 2
  min_size          = 1
  max_size          = 3

  target_group_arns = [module.frontend_alb.target_group_arn]

  
}

module "backend_ec2" {
  source = "./modules/ec2"

  name              = "backend"
  ami               = var.ami
  instance_type     = "t3.micro"

  key_name = aws_key_pair.ansible_key.key_name

  subnets           = module.network.private_subnets
  security_groups   = [module.network.backend_sg]

  desired_capacity  = 2
  min_size          = 1
  max_size          = 3

  target_group_arns = [module.backend_alb.target_group_arn]

  
}


## LB
module "frontend_alb" {
  source = "./modules/alb"

  name            = "frontend-alb"
  internal        = false

  subnets         = module.network.public_subnets
  security_groups = [module.network.alb_front_sg]
  vpc_id          = module.network.vpc_id

  port             = 80
  listener_port    = 80
  health_check_path = "/"
}

module "backend_alb" {
  source = "./modules/alb"

  name            = "backend-alb"
  internal        = true

  subnets         = module.network.private_subnets
  security_groups = [module.network.alb_backend_sg]
  vpc_id          = module.network.vpc_id

  port             = 5000
  listener_port    = 80
  health_check_path = "/health"
}

## Bastion
module "bastion" {
  source = "./modules/bastion"

  ami            = var.ami
  instance_type  = "t3.micro"

  public_subnet  = module.network.public_subnets[0]
  bastion_sg     = module.network.bastion_sg
  key_name       = aws_key_pair.ansible_key.key_name
}

## Database (PostgreSQL)
module "rds" {
  source = "./modules/rds"

  db_name         = "emergencyDB"
  db_username     = "postgres"
  db_password     = "postgres" 
  db_sg_id        = module.network.db_sg
  private_subnets = module.network.private_subnets
}


# This resource automatically creates the backend.yml file locally
resource "local_file" "ansible_backend_vars" {
  filename = "./three-tier-proj-ansible/group_vars/backend.yml"
  content  = yamlencode({
    ansible_ssh_common_args: "-o StrictHostKeyChecking=no -o ProxyCommand=\"ssh -W %h:%p -q ec2-user@${module.bastion.public_ip} -o StrictHostKeyChecking=no\""
    db_host: module.rds.db_host
    db_user: module.rds.db_user
    db_password: module.rds.db_password
    db_name: module.rds.db_name     
    
  })
}

# This resource automatically creates the frontend.yml file
resource "local_file" "ansible_frontend_vars" {
  filename = "./three-tier-proj-ansible/group_vars/frontend.yml"
  content  = yamlencode({
    # This is the URL the Frontend needs to talk to the Backend
    alb_dns_name: module.backend_alb.alb_dns_name
  })
}
