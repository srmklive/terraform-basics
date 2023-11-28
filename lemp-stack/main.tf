terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {}

module "web" {
  source = "./modules/web"

  ami           = var.ami
  instance_type = var.instance_type
  instance_tag  = var.instance_tag
  key_name      = var.key_name
  subnet_id     = aws_subnet.tf-web.id
  vpc_id        = aws_vpc.tf-vpc.id
}

resource "random_password" "mysql" {
  length = 16
  special = true
  override_special = "_%@"
}

module "db" {
  source = "./modules/mysql"
  depends_on = [module.web, random_password.mysql]

  ami           = var.ami
  instance_type = var.instance_type
  instance_tag  = var.instance_tag
  key_name      = var.key_name
  subnet_id     = aws_subnet.tf-web.id
  vpc_id        = aws_vpc.tf-vpc.id
  sg_tf_web     = module.web.sg_tf_web
  mysql_root_password = random_password.mysql.result
}
