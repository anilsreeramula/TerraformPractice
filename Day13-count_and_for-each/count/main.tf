resource "aws_instance" "multipleservers" {
    ami = "ami-06445ac85e0d277a9"
    instance_type = "t3.small"
    #count = 3 
    # (dev,test,prod)
    count = length(var.env)

    tags = {
       #Name - "Dev"
       #Name = "Dev-${count.index}"

       Name = var.env[count.index]

       # index always start from 0,1,2...
    }
}





