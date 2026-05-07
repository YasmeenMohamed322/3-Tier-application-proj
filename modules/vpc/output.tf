output "vpc_id" {
  value = aws_vpc.mainVPC.id
}

output "public_subnets" {
  value = aws_subnet.publicSubnet[*].id
}

output "private_subnets" {
  value = aws_subnet.privateSubnet[*].id
}

output "nat_eip_per_az" {
  value = {
    for i in range(length(var.azs)) :
    var.azs[i] => aws_eip.nat[i].public_ip
  }
}

output "nat_eip_ids" {
  value       = aws_eip.nat[*].id
}

output "frontend_sg" {
  value = aws_security_group.frontend_sg.id
}

output "backend_sg" {
  value = aws_security_group.backend_sg.id
}

output "db_sg" {
  value = aws_security_group.db_sg.id
}

output "bastion_sg" { 
  value = aws_security_group.bastion_sg.id 
  }