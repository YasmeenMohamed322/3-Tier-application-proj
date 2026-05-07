output "public_ip" {
  description = "The public IP of the bastion host for SSH access"
  value = aws_instance.bastion.public_ip
}
output "bastion_id" {
  description = "The ID of the bastion instance"
  value       = aws_instance.bastion.id
}