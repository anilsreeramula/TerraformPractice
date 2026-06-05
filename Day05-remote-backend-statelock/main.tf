resource "aws_instance" "linux_instance" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname
    }
}

resource "aws_instance" "server" {
  ami = var.aminame
  instance_type = var.instancetype
  tags = {
        Name = var.tagname03
         }
} 
