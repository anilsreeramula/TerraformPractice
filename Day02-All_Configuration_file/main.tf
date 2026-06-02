resource "aws_vpc" "name" {
    cidr_block = "192.0.0.0/16"
    tags = {
    Name = "my_auto_vpc" 
    }
}

resource "aws_subnet" "name" {
    vpc_id = aws_vpc.name.id
    cidr_block = "192.0.0.0/24"
    tags = {
        Name = "my_auto_subnet01"
    }
}   
resource "aws_subnet" "name2" {
    vpc_id = aws_vpc.name.id
    cidr_block = "192.0.1.0/24"
    tags = {
        Name = "my_auto_subnet02"
    }
}
resource "aws_instance" "name" {
    ami = var.aminame
    instance_type = var.instancetype
    subnet_id = aws_subnet.name2.id
    tags = {
        Name = var.tagname
    }
}
