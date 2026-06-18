provider "aws" {
    region = "ap-south-1"
    profile = "dev" 
    alias = "dev_user" # this is be used in the main.tf to call the provider block
}

provider "aws" {
  region = "ap-south-2"
  profile = "test"
  alias = "test_user" #this is be used in the main.tf to call the provider block
}

provider "aws" {
  region = "ca-central-1"
}