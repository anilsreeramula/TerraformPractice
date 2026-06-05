#######################################
# VPC
#######################################

resource "aws_vpc" "Dev-VPC" {
  cidr_block           = "192.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Dev-VPC"
  }
}

#######################################
# Public Subnet
#######################################

resource "aws_subnet" "Dev-publicSubnet" {
  vpc_id                  = aws_vpc.Dev-VPC.id
  cidr_block              = "192.0.0.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Dev-publicSubnet"
  }
}

#######################################
# Private Subnet
#######################################

resource "aws_subnet" "Dev-privateSubnet" {
  vpc_id            = aws_vpc.Dev-VPC.id
  cidr_block        = "192.0.1.0/24"
  availability_zone = "ca-central-1b"

  tags = {
    Name = "Dev-privateSubnet"
  }
}

#######################################
# Internet Gateway
#######################################

resource "aws_internet_gateway" "Dev-IGW" {
  vpc_id = aws_vpc.Dev-VPC.id

  tags = {
    Name = "Dev-IGW"
  }
}

#######################################
# Public Route Table
#######################################

resource "aws_route_table" "Dev-publicRT" {
  vpc_id = aws_vpc.Dev-VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Dev-IGW.id
  }

  tags = {
    Name = "Dev-publicRouteTable"
  }
}

resource "aws_route_table_association" "Dev-publicRT-association" {
  subnet_id      = aws_subnet.Dev-publicSubnet.id
  route_table_id = aws_route_table.Dev-publicRT.id
}

#######################################
# Elastic IP for NAT Gateway
#######################################

resource "aws_eip" "Dev-EIP" {
  domain = "vpc"

  tags = {
    Name = "Dev-EIP"
  }
}

#######################################
# NAT Gateway
#######################################

resource "aws_nat_gateway" "Dev-NATGW" {
  allocation_id = aws_eip.Dev-EIP.id
  subnet_id     = aws_subnet.Dev-publicSubnet.id

  depends_on = [
    aws_internet_gateway.Dev-IGW
  ]

  tags = {
    Name = "Dev-NATGW"
  }
}

#######################################
# Private Route Table
#######################################

resource "aws_route_table" "Dev-privateRT" {
  vpc_id = aws_vpc.Dev-VPC.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Dev-NATGW.id
  }

  tags = {
    Name = "Dev-privateRouteTable"
  }
}

resource "aws_route_table_association" "Dev-privateRT-association" {
  subnet_id      = aws_subnet.Dev-privateSubnet.id
  route_table_id = aws_route_table.Dev-privateRT.id
}

#######################################
# Security Group
#######################################

resource "aws_security_group" "Dev-SG" {
  name        = "Dev-SG"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.Dev-VPC.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Dev-SG"
  }
}

#######################################
# Public EC2 Instance
#######################################

resource "aws_instance" "Devappserver01" {
  ami                    = "ami-06445ac85e0d277a9"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.Dev-publicSubnet.id
  vpc_security_group_ids = [aws_security_group.Dev-SG.id]

  tags = {
    Name = "Dev-appserver01"
  }
}

#######################################
# Private EC2 Instance
#######################################

resource "aws_instance" "Devappserver02" {
  ami                    = "ami-06445ac85e0d277a9"
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.Dev-privateSubnet.id
  vpc_security_group_ids = [aws_security_group.Dev-SG.id]

  tags = {
    Name = "Dev-appserver02"
  }
}

