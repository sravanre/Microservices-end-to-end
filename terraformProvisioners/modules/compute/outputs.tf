#-----compute/outputs.tf-----
#=============================
output "app_server" {
  value = aws_instance.app_server.public_ip
}
