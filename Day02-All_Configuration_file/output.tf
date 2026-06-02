output "instance_public_ip" {
  value = aws_instance.name.public_ip
  description = "Public IP address of the EC2 instance"
}
output "instance_id" {
  value = aws_instance.name.id
  description = "ID of the EC2 instance"
}
output "vpc_id" {
  value = aws_vpc.name.id
  description = "ID of the VPC"
}
output "subnet_id" {
  value = aws_subnet.name2.id
  description = "ID of the Subnet"
}
output "instance_private_ip" {
  value = aws_instance.name.private_ip
  description = "Private IP address of the EC2 instance"
}
