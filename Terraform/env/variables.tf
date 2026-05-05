variable "public_key_path" {
  type = string
}
variable "ami" {
  type = string
}
variable "private_subnets" {
  type = list(string)
}
variable "public_subnets" {
  type = list(string)
}
variable "frontend_sg" {
  type = list(string)
}
variable "backend_sg" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "frontend_alb_sg" {
  type = string
}

variable "backend_alb_sg" {
  type = string
}