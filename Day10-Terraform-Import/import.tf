resource "aws_instance" "name" {
    ami           = "ami-0e80e7e160cbfbc53"   
    instance_type = "t3.micro"  
    tags = {
        Name = "myappserver01"
    }
}

# Import S3 bucket
resource "aws_s3_bucket" "my_bucket" {
    bucket = "paras-ak-s3bucket"
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
    bucket = aws_s3_bucket.my_bucket.id
    versioning_configuration {
        status = "Enabled"
    }
}