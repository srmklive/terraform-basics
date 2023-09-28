variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_tag" {
  type = string
}

variable "key_name" {
  default = "TF-TEST"
}

variable "availability_zone" {
  default = "us-east-1"
}

variable "mysql_root_password" {
  description = "MySQL Root User Password"
  default = "root"
}
