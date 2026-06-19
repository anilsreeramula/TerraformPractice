provider "aws" {
  region = "ca-central-1"
}

# this is resource block which is used in the main.tf 
resource "aws_instance" "myec2" {
  ami           = var.aminame
  instance_type = var.instancetype
  
  tags = {
    Name = var.tagname
  }
}