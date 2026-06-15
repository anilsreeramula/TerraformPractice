
resource "aws_vpc" "myvpc" {
    cidr_block = "192.0.0.0/16"
}

resource "aws_subnet" "subnet01" {
    vpc_id            = aws_vpc.myvpc.id
    cidr_block        = "192.0.0.0/24"
}
resource "aws_subnet" "subnet02" {
    vpc_id           = aws_vpc.myvpc.id
    cidr_block       = "192.0.1.0/24"
  
}


resource "aws_security_group" "mysg" {
    name        = "my-security-group"
    description = "Security group with multiple inbound rules from same source"
    vpc_id      = aws_vpc.myvpc.id
 
 # we can use for loop to create multiple ingress rules with same source but different ports

    ingress = [
     # port is just a name, we can use any name   and for is aaa "forloop " which reapets till the defined list is completed
     for port in var.sgrule : {

        description      = "Allow HTTP traffic from anywhere"
        from_port        = port
        to_port          = port
        ipv6_cidr_blocks = []
        prefix_list_ids  = []
        security_groups   = []
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        self             = false
    
    }
    ]
}

resource "aws_instance" "myserver" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.small"
    vpc_security_group_ids = [aws_security_group.mysg.id]
    subnet_id = aws_subnet.subnet02.id
    tags = {
        Name = "appserver01"
    }
}