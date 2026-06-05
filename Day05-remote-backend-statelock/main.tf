resource "aws_instance" "linux_instance" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname
    }
}