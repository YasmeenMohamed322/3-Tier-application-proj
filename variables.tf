variable "AWS_ACCESS_KEY_ID" {
  type      = string
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  type      = string
  sensitive = true
}


variable "vpc_id" {
  type    = string
  
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "frontend_sg" {
  type = string

}

variable "backend_sg" {
  type = string

}

variable "frontend_alb_sg" {
  type    = string
  
}

variable "backend_alb_sg" {
  type    = string
  
}

variable "ami" {
  type    = string
  default = "ami-0eb38b817b93460ac"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "public_key_path" {
  type    = string
  default = "id_rsa.pub"
}

variable "bastion_sg" {
  type    = string
  
}
