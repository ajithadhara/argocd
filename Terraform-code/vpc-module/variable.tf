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
