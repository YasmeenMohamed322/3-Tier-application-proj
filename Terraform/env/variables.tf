#variable "public_key_path" {
 # type = string
#}
#variable "ami" {
 # type = string
#}
#variable "private_subnets" {
 # type = list(string)
#}
#variable "public_subnets" {
 # type = list(string)
#}
#variable "frontend_sg" {
 # type = list(string)
#}
#variable "backend_sg" {
 # type = list(string)
#}
#variable "vpc_id" {
 # type = string
#}

#variable "public_subnets" {
  #type = list(string)
#}

#variable "private_subnets" {
 # type = list(string)
#}

#variable "frontend_alb_sg" {
  #type = string
#}

#variable "backend_alb_sg" {
  #type = string
#}


variable "vpc_id" {
  type    = string
  default = "vpc-12345678"
}

variable "public_subnets" {
  type = list(string)

  default = [
    "subnet-11111111",
    "subnet-22222222"
  ]
}

variable "private_subnets" {
  type = list(string)

  default = [
    "subnet-33333333",
    "subnet-44444444"
  ]
}

variable "frontend_sg" {
  type = string

  default = "sg-frontend123"
}

variable "backend_sg" {
  type = string

  default = "sg-backend123"
}

variable "frontend_alb_sg" {
  type    = string
  default = "sg-frontendalb123"
}

variable "backend_alb_sg" {
  type    = string
  default = "sg-backendalb123"
}

variable "ami" {
  type    = string
  default = "ami-12345678"
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
  default = "sg-bastion123"
}