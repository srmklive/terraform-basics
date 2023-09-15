resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_tag
  }

  user_data = file("${path.module}/lemp_ubuntu.sh")

  root_block_device {
    delete_on_termination = "true"
  }
}
