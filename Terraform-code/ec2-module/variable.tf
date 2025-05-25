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

variable "subnet_ids" {
  type = list(string)
}

variable "security_groups_id" {
  type = string
} 

variable "key_name" {
  type = string
  description = "the key name"
}
variable "volume_size" {
  type = number
  description = "the size of volume"
}

variable "volume_type" {
  type = string
  description = "the type of volume"
}
