variable "ami" {
  default = "ami-0261755bbcb8c4a84"
}

variable instance_type {
  description = "Instance Type to provision for EC2"
  default = "t2.nano"
}

variable "instance_tag" {
  default = "Terraform EC2 Test"
}

variable "key_name" {
  description = "SSH Key used for the servers."
}

variable "subnet_id" {
  description = "Subnet ID information for the DB servers."
}

variable "vpc_id" {
  description = "VPC ID information for TF servers."
}

variable "sg_tf_web" {
  description = "Web Server Security group ID"
}

variable "mysql_root_password" {
  description = "MySQL Root User Password"
}

variable "mysql_password_file" {
  description = "File containing password for MySQL Root User."
  default = "mysql_root_password.txt"
}