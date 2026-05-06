#create vpc
resource "aws_vpc" "mainVPC" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "mainVPC"
  }
}

#public subnets
resource "aws_subnet" "publicSubnet" {
  count = length(var.public_subnets)

  vpc_id                  = aws_vpc.mainVPC.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "publicSubnet-${count.index}"
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
  }
}

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

#allocate elastic IP for NAT gateway
resource "aws_eip" "nat" {
  count  = length(var.public_subnets)
  domain = "vpc"

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

#security group for frontend instances
resource "aws_security_group" "frontend_sg" {
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontendSG"
  }
}

#security group for backend instances
resource "aws_security_group" "backend_sg" {
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend_sg.id]
  }

  tags = {
    Name = "backendSG"
  }
}

#security group for database instances
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.mainVPC.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.backend_sg.id]
  }

  tags = {
    Name = "dbSG"
  } 
}