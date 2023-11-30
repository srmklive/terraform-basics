resource "aws_security_group" "sg-test-web" {
  name = "sg_test_web"
  description = "Security Group for Web Server"
  vpc_id = var.vpc_id

  ingress {
    from_port = "80"
    to_port = "80"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "443"
    to_port = "443"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
}

resource "aws_instance" "web_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.sg-test-web.id]
  subnet_id              = var.subnet_id
  user_data              = file("${path.module}/lemp_ubuntu.sh")

  tags = {
    Name = var.instance_tag
  }

  provisioner "file" {
    source      = "${path.module}/default-host.conf"
    destination = "/home/ubuntu/default-host.conf"
  }

  provisioner "file" {
    source      = "${path.module}/www.conf"
    destination = "/home/ubuntu/www.conf"
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /server/http",
      "sudo sed -i -e 's/\r$//' /home/ubuntu/lemp_ubuntu.sh",
      "composer global require laravel/installer -n",
      "export PATH=$PATH:\"/home/ubuntu/.config/composer/vendor/bin\"",
      "sudo chown ubuntu:www-data -R /server/http",
      "cd /server/http && laravel new web-app --jet --stack livewire -n",
      "cd /server/http/web-app && sudo chmod 777 -R storage bootstrap/cache",
      "sudo cp /home/ubuntu/default-host.conf /etc/nginx/conf.d/default.conf",
      "sudo cp /home/ubuntu/www.conf /etc/php/8.2/fpm/pool.d/www.conf",
      "sudo service php8.2-fpm restart",
      "sudo service nginx restart"
    ]
  }

  root_block_device {
    delete_on_termination = "true"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    password = ""
    host     = self.public_ip
    private_key = file("${path.module}/../../../${var.key_name}.pem")
  }
}

resource "aws_ami_from_instance" "tf-ami" {
  name               = "tf-test-ami"
  source_instance_id = "${element(aws_instance.web_server.*.id, 0)}"
}
