#-----compute/main.tf-----
#==========================
provider "aws" {
  region = var.region
}

#Get Linux AMI ID using SSM Parameter endpoint
#==============================================
data "aws_ssm_parameter" "webserver-ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

#Create key-pair for logging into EC2 
#======================================
resource "aws_key_pair" "aws-key" {
  key_name   = "app_server"
  public_key = file(var.ssh_key_public)
}


#Create and bootstrap App Server
#===============================
resource "aws_instance" "app_server" {

  instance_type               = "t2.medium"
  ami                         = data.aws_ssm_parameter.webserver-ami.value
  tags = {
  Name = "app_server"
  }
  key_name                    = aws_key_pair.aws-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.security_group]
  subnet_id                   = var.subnets

  connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key   = file(var.ssh_key_private)
      host        = self.public_ip
  }

  # Copy the file from local machine to EC2
  provisioner "file" {
    source      = "install_app_server.yaml"
    destination = "install_app_server.yaml"
  }

  # Execute a script on a remote resource
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y && sudo yum install ansible -y && sudo yum install java-11-amazon-corretto -y",
      "sleep 60s",
      "ansible-playbook install_app_server.yaml"
    ]
 }
}