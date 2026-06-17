resource "aws_vpc" "myvpc" {
  cidr_block = var.cidrblock
   tags = {
    Name = var.vpcname
  }
}