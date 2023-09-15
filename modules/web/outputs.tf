output "url" {
  value = "http://${aws_instance.web_server.public_ip}"
}

output "public_ip" {
  value = "${aws_instance.web_server.public_ip}"
}

output "private_ip" {
  value = "${aws_instance.web_server.private_ip}"
}

output "ec2_arn" {
  value = aws_instance.web_server.arn
}