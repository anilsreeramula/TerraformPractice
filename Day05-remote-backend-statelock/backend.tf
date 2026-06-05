terraform{
  backend "s3" {
    bucket = "paras123-statefilebucket"
    key    = "terraform.tfstate"
    region = "ca-central-1"
    dynamodb_table = "statelock"
    encrypt = true
    #use_lockfile = true
    }
}