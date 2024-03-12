  //this is vpc 
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

//this is security group
resource "aws_security_group" "my_sg" {
  vpc_id = "aws_vpc.my_vpc.id"
  name   = "this_sg"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { 
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//this is public subnet
resource "aws_subnet" "public" {
  vpc_id            = "aws_vpc.my_vpc.id"
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public"
  }
  map_public_ip_on_launch = true
}

//this is private subnet
resource "aws_subnet" "private" {
  vpc_id            = "aws_vpc.my_vpc.id"
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private"
  }
  map_public_ip_on_launch = false
}
resource "aws_subnet" "private_ins" {
  vpc_id            = "aws_vpc.my_vpc.id"
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1c"
  tags = {
    Name = "private_ins"
  }
  map_public_ip_on_launch = false
}

//this is internet-gateway
resource "aws_internet_gateway" "my_ig" {
  vpc_id = "aws_vpc.my_vpc.id"
  tags = {
    Name = "my_ig"
  }
}

//this is natgateway
resource "aws_network_interface" "sid" {
  subnet_id = "aws_subnet.public.id"
  tags = {
    Name = "sid"
  }
}

//this is route table
resource "aws_route_table" "my_route" {
  vpc_id = "aws_vpc.my_vpc.id"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = [aws_internet_gateway.my_ig.id]
    }

  tags = {
    Name = "my_route"
  }
}

//this is route-association with
resource "aws_route_table_association" "route_association" {
   subnet_id      = "aws_subnet.public.id"
   route_table_id = "aws_route_table.my_route.id"
 }

//this is instance
resource "aws_instance" "my_instance" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  vpc_security_group_ids = "aws_security_group.my_sg.id"
  subnet_id              = "aws_subnet.public.id"
  tags = {
    Name = "my_instance"
  }
  root_block_device {
    volume_size = 8
  }
  //install jenkins 
  user_data        = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
    sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    sudo yum upgrade
    sudo dnf install java-17-amazon-corretto -y
    sudo yum install jenkins -y
    sudo systemctl enable jenkins
    sudo systemctl start jenkins
    EOF
}
//this Provides an RDS DB subnet group
resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "this_subnet_group"
  subnet_ids = "aws_subnet.private.id, aws_subnet.private_ins.id"
  tags = {
    Name = "my_subnet_group"
  }
}

