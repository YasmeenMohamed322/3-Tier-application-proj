# 1. Subnet Group for RDS
resource "aws_db_subnet_group" "subnet_gp" {
  name       = "postgres-subnet-group"
  subnet_ids = var.private_subnets

  tags = { Name = "PostgresSubnetGroup" }
}

# 2. PostgreSQL Instance
resource "aws_db_instance" "rds" {
  allocated_storage    = 20
  engine               = "postgres"
#  engine_version       = "15.5" 
  instance_class       = "db.t3.micro"
  
  db_name              = var.db_name     
  username             = var.db_username 
  password             = var.db_password
  
  db_subnet_group_name   = aws_db_subnet_group.subnet_gp.name
  vpc_security_group_ids = [var.db_sg_id]
  
  skip_final_snapshot  = true
  publicly_accessible  = false # Kept private for security
  multi_az = false    # set multi_az to false if the AWS account is free tier, otherwise set to true to enable the feature

  tags = { Name = "MainPostgresDB" }
}
