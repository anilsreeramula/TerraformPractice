variable "apple" {
  default = ""
}

variable "acl" {
  default = " "
  
}
variable "control_object_ownership" {
  type = bool 
}
variable "object_ownership" {
  default = " "
 
}
variable "versioning" {
  default = { 
   
  }
}

# variable.tf file is used to define the variables that are used in the main.tf file. 
# This file is used to declare the variables that are used in the main.tf file. 
# this vlaues are used locally in the main.tf file.
