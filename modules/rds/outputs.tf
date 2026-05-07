output "db_host" {
  value = aws_db_instance.this.address
}

output "db_user" {
  value = aws_db_instance.this.username
}

output "db_password" {
  value     = aws_db_instance.this.password
  sensitive = true # Keeps it hidden in logs, but accessible in outputs
}

output "db_name" {
  value = aws_db_instance.this.db_name
}