resource "aws_s3_bucket" "bucket" {
    bucket = "paras-statelock-bucket"
    region         = "ca-central-1"

}
resource "aws_instance" "name" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname
    }
}
    


resource "aws_vpc" "vpc" {
    cidr_block = "192.0.0.0/16"
}
    
resource "aws_instance" "name02" {
    ami           = var.aminame
    instance_type = var.instancetype
    tags = {
        Name = var.tagname02
    }
}
  




