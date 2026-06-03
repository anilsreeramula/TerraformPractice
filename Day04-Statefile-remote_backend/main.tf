resource "aws_s3_bucket" "bucket" {
    bucket = "paras-remote-backend-s3bucket"
}
resource "aws_instance" "name" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.micro" 
    tags = {
        Name = "app_server_01"
    }
    
}
