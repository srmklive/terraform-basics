variable "ami" {
  default = "ami-0261755bbcb8c4a84"
}

variable "instance_name" {
  default = "app_server"
}

variable instance_type {
  description = "Instance Type to provision for EC2"
  default = "t2.nano"
}

variable "instance_tag" {
  default = "Terraform EC2 Test"
}