variable "name" {}
variable "internal" {
  type = bool
}

variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "vpc_id" {}

variable "port" {
  type = number
}

variable "listener_port" {
  type = number
}

variable "health_check_path" {}