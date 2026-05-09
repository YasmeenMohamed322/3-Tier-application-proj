variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "db_username" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_password" {
  description = "Password for the master DB user"
  type        = string
  sensitive   = true
}

variable "db_sg_id" {
  description = "The Security Group ID allowed to access the DB"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for the DB Subnet Group"
  type        = list(string)
}