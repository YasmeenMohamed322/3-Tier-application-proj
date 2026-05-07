variable "name" {}
variable "ami" {}
variable "instance_type" {}
variable "key_name" {
  type = string
}
variable "security_groups" {
  type = list(string)
}

variable "subnets" {
  type = list(string)
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "target_group_arns" {
  type = list(string)
}

variable "user_data" {
  default = ""
}