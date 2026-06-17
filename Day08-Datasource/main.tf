provider "aws" {
 region = "ca-central-1"

}
# this block of subnet is already existing, insted of creating a new VPC and subnet
# we are using the already created on, same is the case with the security group

data "aws_subnet" "mysubnet"{
filter {
      name = "tag:Name"
      values = ["cust-subnet01"]
       }
}

data "aws_security_group" "sg"{
filter {
      name   = "tag:Name"
      values = ["cust-sg"]
       }
}

# We are creting a Instance in the specific subnet and specific security group
resource "aws_instance" "server" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.small"
    subnet_id     = data.aws_subnet.mysubnet.id
    security_groups  = [data.aws_security_group.sg.id]
    tags = {
        Name = "app_server_02"
    }
}