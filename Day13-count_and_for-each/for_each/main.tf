resource "aws_instance" "name" {
    ami = "ami-06445ac85e0d277a9"
    instance_type = "t3.micro"
    for_each = toset(var.env)

    tags = {
      Name = each.key
  
}
}