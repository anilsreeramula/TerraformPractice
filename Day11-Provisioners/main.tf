####################################
# KEY PAIR
####################################

resource "aws_key_pair" "mykey" {
  key_name   = "terraform-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

####################################
# VPC
####################################

resource "aws_vpc" "main" {
  cidr_block           = "192.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "Main-VPC"
  }
}

####################################
# INTERNET GATEWAY
####################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main-IGW"
  }
}

####################################
# SUBNET AZ-1
####################################

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.0.1.0/24"
  availability_zone       = "ca-central-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-AZ1"
  }
}

####################################
# SUBNET AZ-2
####################################

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.0.2.0/24"
  availability_zone       = "ca-central-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Subnet-AZ2"
  }
}

####################################
# ELASTIC IP
####################################

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

####################################
# NAT GATEWAY
####################################

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet1.id

  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "Main-NAT"
  }
}

####################################
# PUBLIC ROUTE TABLE
####################################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public-RT"
  }
}

####################################
# ROUTE TABLE ASSOCIATIONS
####################################

resource "aws_route_table_association" "rt1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt2" {
  subnet_id      = aws_subnet.subnet2.id
  route_table_id = aws_route_table.public_rt.id
}

####################################
# SECURITY GROUP
####################################

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH and HTTP"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

####################################
# EC2 INSTANCE - AZ1
####################################

resource "aws_instance" "server1" {
  ami                    = "ami-06445ac85e0d277a9"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet1.id
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Server-AZ1"
  }
connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}


####################################
# EC2 INSTANCE - AZ2
####################################

resource "aws_instance" "server2" {
  ami                    = "ami-06445ac85e0d277a9"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.subnet2.id
  key_name               = aws_key_pair.mykey.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Server-AZ2"
  }
}
