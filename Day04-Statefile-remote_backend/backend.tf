terraform {
  backend "s3" {
    bucket = "paras-remote-backend-s3bucket"
    key    = "terraform.tfstate"
    region = "ca-central-1"
    }
}