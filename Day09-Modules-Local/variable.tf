variable "instance_name" {
  type = string
  default = "appserver01" 
}
variable "ami_id" {
  type = string
  default = " "
}

variable "instance_type" {
  type = string
  default = ""
}
variable "subnet_id" {
  type = string
  default = " "
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

