#create vpc
resource "aws_vpc" "mainVPC" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true #assign public dns for resources with public ip
  enable_dns_support   = true #enables route 53 help instance resolve external domains
  tags = {
    Name = "mainVPC"
  }
}


###SUBNETs###
#public subnets
resource "aws_subnet" "publicSubnet" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.mainVPC.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "publicSubnet-${count.index}"
    Network = "Public"
  }
}

#private subnets
resource "aws_subnet" "privateSubnet" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.mainVPC.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name = "privateSubnet-${count.index}"
    Network = "Private"
  }
}

####IGW & its Route table####
# one internet gateway shared
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mainVPC.id

  tags = {
    Name = "mainIGW"
  }
}

# create route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.mainVPC.id

  tags = {
    Name = "Public-rtb"
  }
}

#route for public subnets to access internet
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#associate public subnets with route table
resource "aws_route_table_association" "public" {
  count = length(aws_subnet.publicSubnet)

  subnet_id      = aws_subnet.publicSubnet[count.index].id
  route_table_id = aws_route_table.public.id
}


####NAT GW and ROUTE####
#allocate elastic IP for NAT gateway
resource "aws_eip" "nat" {
  count  = length(var.public_subnets)
  domain = "vpc"
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "NatEIP-${count.index}"
  }
}

#create NAT gateway for each public subnet
resource "aws_nat_gateway" "nat" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.publicSubnet[count.index].id

  tags = {
    Name = "NatGateway-${count.index}"
  }

}
##>>
#create route table for private subnets 
resource "aws_route_table" "private" {
  count = length(var.private_subnets) 
  vpc_id = aws_vpc.mainVPC.id

  tags = {
    Name = "Private-rtb-${count.index}"
  }
}
resource "aws_route" "private_nat" {
  count = length(var.private_subnets)
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.privateSubnet)
  subnet_id      = aws_subnet.privateSubnet[count.index].id
  route_table_id = aws_route_table.private[count.index].id 
}
##>>

#security group for ALB frontend
resource "aws_security_group" "alb_front_sg" {
  name   = "ALB-FrontendSG"
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = {
    Name = "ALB-FrontendSG"
  }
}

#security group for frontend instances
resource "aws_security_group" "frontend_sg" {
  name   = "FrontendSG"
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_front_sg.id]
  }


egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FrontendSG"
  }
}

#security group for ALB Backend
resource "aws_security_group" "alb_backend_sg" {
  name   = "ALB_BackendSG"
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "ALB-BackendSG"
  }
}

#security group for backend instances
resource "aws_security_group" "backend_sg" {
  name   = "BackendSG"
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_backend_sg.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # SSH only from Bastion
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "BackendSG"
  }
}

#security group for database instances from be only 
resource "aws_security_group" "db_sg" {
  name   = "db_sg"
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dbSG"
  } 
}

# BASTION SG: Only entry point for SSH
resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "Allow SSH from my local machine"
  vpc_id      = aws_vpc.mainVPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = {
    Name = "BastionSG"
  }
}
