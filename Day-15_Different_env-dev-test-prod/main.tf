resource "aws_s3_bucket" "devbuccket" {
  bucket = "paras456devbucket"
  provider = aws.dev_user # this will search for the dev_user (alias name) and invoke the provider block 
                          # and the profile will be used to create the defined resource block.   
}
resource "aws_s3_bucket" "testbucket" {
    bucket = "paras456testbucket"
    provider = aws.test_user
}

resource "aws_instance" "ec2" {
    ami           = "ami-06445ac85e0d277a9"
    instance_type = "t3.micro"
tags = {
  Name = "appserver01"
}

}

resource "aws_instance" "test_ec2" {
    ami           = "ami-04a64102b8022e4f3"
    instance_type = "t3.micro"
    provider = aws.test_user
tags = {
  Name = "testserver"
}

}

resource "aws_instance" "dev_ec2" {
    ami           = "ami-0e38835daf6b8a2b9"
    instance_type = "t3.small"
    provider = aws.dev_user
tags = {
  Name = "devserver"
}


}