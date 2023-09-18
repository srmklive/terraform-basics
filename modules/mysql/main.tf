# Create the security group for web server
resource "aws_security_group" "test-db" {
  name = "test-db"
  description = "Security Group for DB Server"
  vpc_id = var.vpc_id

  ingress {
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    security_groups = [var.sg_tf_web]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database ${var.instance_tag}"
  }
}

# Create an EC2 instance
resource "aws_instance" "db" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.test-db.id]
  subnet_id = var.subnet_id

  tags = {
    Name = "Database ${var.instance_tag}"
  }

  root_block_device {
    delete_on_termination = "true"
  }
}