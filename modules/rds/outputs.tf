output "db_host" {
  value = aws_db_instance.rds.address
}

output "db_user" {
  value = aws_db_instance.rds.username
}

output "db_password" {
  value     = aws_db_instance.rds.password
  sensitive = true # Keeps it hidden in logs, but accessible in outputs
}

output "db_name" {
  value = aws_db_instance.rds.db_name
}