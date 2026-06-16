# Example -1

# variable "dev" {
#   type = bool
#   default = false
# }

# resource "aws_instance" "ec2" {
#   ami           = "ami-06445ac85e0d277a9"
#   instance_type = "t3.micro"
#   count = var.dev ? 0:3
    
# }
# ==========================================

#Example -2

# variable "aws_region" {
#   description = "The region in which to create the infrastructure"
#   type        = string
#   nullable    = false
#   default     = "ap-south-2" #here we need to define the below mentioned regions only, if i give other region it will get error 
#   validation {
#     condition = var.aws_region == "us-east-1" || var.aws_region == "ap-south-1" || var.aws_region == "ca-central-1"
#     error_message = "The variable 'aws_region' must be one of the following regions: us-east-1, ap-south-1, ca-central-1"
#   }
# }
# provider "aws" {
#   region = var.aws_region
  
   
#  }
#  resource "aws_s3_bucket" "dev" {
#     bucket = "akstatefile-configuresssdsfsff"
          
# }

# Example -3

variable "environment" {
  type    = string
  default = "prod"
}
resource "aws_instance" "example" {
  count         = var.environment == "prod" ? 3 : 1
  ami           = "ami-02dfbd4ff395f2a1b"
  instance_type = "t2.micro"
  tags = {
    Name = "example-${count.index}"
  }
}
# #In this case:
# #If var.environment == "prod" â count = 3
# #Else (like dev, qa, etc.) â count = 1
# #terraform apply -var="environment=dev"