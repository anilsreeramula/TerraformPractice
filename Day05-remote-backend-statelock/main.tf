resource "aws_instance" "linux_instance" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname
    }
}


resource "aws_instance" "linux_Server" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname02
    }
}
