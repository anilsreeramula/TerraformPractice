resource "aws_s3_bucket" "mys3bucket" {
  bucket = "paras4567uniquetfbucket"
    tags = {
        Name = "my_bucket"
    }
    depends_on = [aws_instance.name]
}




resource "aws_vpc" "cust-vpc" {
  cidr_block = "192.0.0.0/16"
    tags = {
        Name = "cust-vpc"
    }
  
}   

resource "aws_subnet" "cust-subnet01" {
  vpc_id            = aws_vpc.cust-vpc.id
  cidr_block        = "192.0.0.0/24"
    availability_zone = "ca-central-1a"
        tags = {
            Name = "cust-subnet01"
        }
}

resource "aws_subnet" "cust-subnet02" {  
  vpc_id            = aws_vpc.cust-vpc.id
  cidr_block        = "192.0.1.0/24"
    availability_zone = "ca-central-1b"
        tags = {
            Name = "cust-subnet02"
        }
}

resource "aws_security_group" "cust-sg" {
  vpc_id = aws_vpc.cust-vpc.id
    tags = {
        Name = "cust-sg"
    }
ingress {
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


resource "aws_instance" "name" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.micro" 
    tags = {
        Name = "app_server_01"
    }
    
}