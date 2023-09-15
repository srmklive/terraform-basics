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
}
