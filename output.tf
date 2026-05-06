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

