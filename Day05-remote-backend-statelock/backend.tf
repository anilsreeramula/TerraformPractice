terraform{
  backend "s3" {
    bucket = "paras123-statefilebucket"
    key    = "terraform.tfstate"
    region = "ca-central-1"
    use_lockfile = true
    }
}