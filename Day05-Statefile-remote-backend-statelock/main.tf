resource "aws_instance" "name" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname
    }
}
    


resource "aws_vpc" "vpc" {
    cidr_block = "192.0.0.0/16"
}
    

resource "aws_subnet" "subnet" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "192.0.1.0/24"
}
