resource "aws_instance" "name" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname
    }
}