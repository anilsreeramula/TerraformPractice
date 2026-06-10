# Passing the values to the module
module "local_instance" {
  source = "../Day09-Modules-Local"
  instance_name        = "my-instance"
  ami_id               = "ami-06445ac85e0d277a9"
  instance_type        = "t3.micro"
  

#ignoring other variables for now

}   