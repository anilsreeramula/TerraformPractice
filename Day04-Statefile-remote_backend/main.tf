resource "aws_s3_bucket" "bucket" {
    bucket = "paras-remote-backend-s3bucket"
}
resource "aws_instance" "name" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.micro" 
    tags = {
        Name = "app_server_01"
    }
    
}

resource "aws_vpc" "vpc" {
    cidr_block = "192.0.0.0/16"
}

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "192.0.0.0/24"
}

resource "aws_instance" "name2" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.small" 
        tags = {
         Name = "app_server_02"
    }
    
}



