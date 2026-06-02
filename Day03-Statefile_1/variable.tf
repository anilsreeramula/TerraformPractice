variable "aminame" {
  description = "AMI ID for the instance"
  default = ""
}
variable "instancetype" {
  description = "Type of the instance"
  default = "t3.small"
}
variable "tagname" {
  description = "Name of the instance"
  default = "my_auto_instance"
}
