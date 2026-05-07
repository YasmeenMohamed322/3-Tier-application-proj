variable "ami" {}
variable "instance_type" {}

variable "public_subnet" {
  type = string
}

variable "bastion_sg" {
  type = string
}

variable "key_name" {
  type = string
}