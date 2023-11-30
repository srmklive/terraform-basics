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

resource "local_file" "password_file" {
  filename = "${path.module}/${var.mysql_password_file}"
  content  = var.mysql_root_password
}

# Create an EC2 instance
resource "aws_instance" "db" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.test-db.id]
  subnet_id = var.subnet_id
  user_data     = file("${path.module}/install_updates.sh")

  tags = {
    Name = "Database ${var.instance_tag}"
  }

  root_block_device {
    delete_on_termination = "true"
  }

  provisioner "file" {
    source      = "${path.module}/install_mysql_ubuntu.sh"
    destination = "/home/ubuntu/install_mysql_ubuntu.sh"
  }

  provisioner "file" {
    source      = "${path.module}/${var.mysql_password_file}"
    destination = "/home/ubuntu/mysql_root_password"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ubuntu/install_mysql_ubuntu.sh",
      "sudo sed -i -e 's/\r$//' /home/ubuntu/install_mysql_ubuntu.sh",
      "cd /home/ubuntu && sudo ./install_mysql_ubuntu.sh"
      "rm -f /home/ubuntu/*mysql*"
    ]
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""
    host     = self.public_ip
    private_key = file("${path.module}/../../../${var.key_name}.pem")
  }
}