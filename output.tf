output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnets" {
  value = module.network.public_subnets
}

output "private_subnets" {
  value = module.network.private_subnets
}

output "nat_eip_per_az" {
  value = module.network.nat_eip_per_az
}

output "frontend_sg" {
  value = module.network.frontend_sg
}

output "backend_sg" {
  value = module.network.backend_sg
}

output "db_sg" {
  value = module.network.db_sg
} 

output "ansible_backend_config" {
  value = {
    db_host     = module.rds.db_host
    db_user     = module.rds.db_user
    db_password = module.rds.db_password
    db_name     = module.rds.db_name
  }
  sensitive = true
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

output "alb_dns_name" {
  description = "The URL to access the frontend"
  value       = module.frontend_alb.alb_dns_name
}