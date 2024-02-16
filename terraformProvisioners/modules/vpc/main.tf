#-----vpc/main.ansible-----
#======================
provider "aws" {
  region = var.region
}

#Get all available AZ's in VPC for this region
#================================================
data "aws_availability_zones" "azs" {
  state = "available"
}

#Create VPC in us-east-1
#========================
resource "aws_vpc" "ansible_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform-VPC"
  }
}

#Create IGW in us-east-1
#========================
resource "aws_internet_gateway" "ansible_igw" {
  vpc_id = aws_vpc.ansible_vpc.id
  tags = {
    Name = "Ansible-Sandbox-Gateway"
  }
}

#Create public route table in us-east-1
#=======================================
resource "aws_route_table" "ansible_public_route" {
  vpc_id = aws_vpc.ansible_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ansible_igw.id
  }
  tags = {
    Name = "Ansible-Sandbox-RouteTable"
  }
}

#Create subnet # 1 in us-east-1 
#===============================
resource "aws_subnet" "ansible_public_subnet" {
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id     = aws_vpc.ansible_vpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "Ansible-Sandbox-Subnet"
  }
}


resource "aws_route_table_association" "ansible_public_assoc" {
  subnet_id          = aws_subnet.ansible_public_subnet.id
  route_table_id     = aws_route_table.ansible_public_route.id
}

#Create SG for allowing TCP/80, TCP/22, TCP/8080, TCP/1233
#=============================================================
resource "aws_security_group" "ansible_public_sg" {
  name        = "ansible_public_sg"
  description = "Used for access to the public instances"
  vpc_id      = aws_vpc.ansible_vpc.id
  #Inbound internet access
  #SSH
  ingress {
    description = "Allow SSH traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTP
  ingress {
    description = "allow traffic from TCP/80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #HTTP
  ingress {
    description = "allow traffic from TCP/5000"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  #HTTP
  ingress {
    description = "allow traffic from TCP/1233"
    from_port   = 1233
    to_port     = 1233
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Ansible-SecurityGroup"
  }
}