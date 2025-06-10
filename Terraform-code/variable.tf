variable "ami" {
  type = string
  description = "the value of ami id"
}

variable "instance_type" {
  type = string
  description = "the type of ec2_instance"
}

variable "ec2_count" {
  type = number
}

variable "key_name" {
  type = string
  description = "the key name"
}

variable "vpc_cidr" {
  type = string
  description = "the cidr range of main vpc"
}

variable "subnet_count" {
  type = number
  description = "the no of subnets"
}

variable "aws_availabilty_zones" {
  type = list(string)
}

variable "volume_size" {
  type = number
}
variable "volume_type" {
  type = string
}
