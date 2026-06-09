# creation of VPC for the RDS instance
resource "aws_vpc" "rds_vpc" {
  cidr_block = "192.0.0.0/16"
    tags = {
        Name = "rds_vpc"
    }
}

# creation of subnet01 for the RDS instance
resource "aws_subnet" "rds_subnet01" {
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "192.0.1.0/24"
    availability_zone = "ca-central-1a"
        tags = {
            Name = "rds_subnet01"
        }
}

# creation of subnet02 for the RDS instance
resource "aws_subnet" "rds_subnet02" {  
  vpc_id            = aws_vpc.rds_vpc.id
  cidr_block        = "192.0.2.0/24"
    availability_zone = "ca-central-1b"
        tags = {
            Name = "rds_subnet02"
        }   
}

#creation of subnet group for the RDS instance
resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.rds_subnet01.id, aws_subnet.rds_subnet02.id]
    tags = {
        Name = "rds_subnet_group"
    }
}   

# creation of security group for the RDS instance
resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instance, allow all traffic "
  vpc_id      = aws_vpc.rds_vpc.id
    tags = {
        Name = "rds_sg"
    }
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
            }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
            }
}   

# Creation of RDS instance
resource "aws_db_instance" "my_rds_instance" {
  identifier              = "rds-instance"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "myterraformDB"
  username                = "admin"
  #password                = "Cloud1234"
# password from screte manager
  manage_master_user_password = true

  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-06:00"
    tags = {
        Name = "rds_instance"
    }
    skip_final_snapshot = true
}

