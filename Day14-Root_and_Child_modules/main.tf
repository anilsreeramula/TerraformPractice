provider "aws" {
  region = "ca-central-1"

}
#
#calling modules inside modules

module "ec2" {           
  source = "./module/ec2"      # calling the ec2 module which is define outside , it has main.tf
  instancetype = "t3.micro"  # passing the values to the variables defined in the modules inside main.tf
  aminame = "ami-06445ac85e0d277a9"
  tagname = "appserver01"

}
module "s3"{
source = "./module/s3"
bucketname = "paras45640087"
 
}
module "vpc" {
source = "./module/vpc"
  cidrblock = "192.0.0.0/16"
  vpcname = "myvpc"
}