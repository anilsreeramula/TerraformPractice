resource "aws_instance" "ec2" {
  ami           = "ami-06445ac85e0d277a9"
  instance_type = "t3.micro"
  
  tags = {
    Name = "MyEC2Instance"
  }
}