resource "aws_instance" "ec2" {
  ami           = "ami-06445ac85e0d277a9"
  instance_type = "t3.micro"
  
  tags = {
    Name = "appserver01"
  }
}

resource "aws_s3_bucket" "mys3" {
  bucket = "paras1234s3bucket"
  region = "ca-central-1"

}

resource "aws_vpc" "VPC" {
  cidr_block = "192.0.0.0/16"
  region = "ca-central-1"
  tags={
    Name = "devvpc"
  }
}

resource "aws_subnet" "subnet01" {
  vpc_id = aws_vpc.VPC.id
  cidr_block = "192.0.1.0/24"
  availability_zone = "ca-centra-1a"
  tags = {
    Name = "pvtsubnet"
  }
}

#terraform apply -target=aws_s3_bucket.name we can target specific resource to apply.
#terraform dewstroy -target=aws_s3_bucket.name we can target specific resource to delete 