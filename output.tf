output "instance_dns" {
  value = aws_instance.employee-app.public_dns
}

output "instance_ip" {
  value = aws_instance.employee-app.public_ip
}