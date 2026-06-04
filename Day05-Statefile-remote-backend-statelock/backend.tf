terraform {
  backend "s3" {
    bucket = "paras-statelock-bucket"
    key    = "terraform.tfstate"
    region = "ca-central-1"
    }
}