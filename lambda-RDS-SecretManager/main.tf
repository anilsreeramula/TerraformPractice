provider "aws" {
  region = "ca-central-1" # Replace with your preferred region
}

# ==========================================
# 1. NETWORKING (VPC & SUBNETS)
# ==========================================

#data "aws_availability_zones" "available" {}

resource "aws_vpc" "main" {
  cidr_block           = "192.0.0.0/16"
#   enable_dns_hostnames = true
#   enable_dns_support   = true

  tags = { Name = "private-lambda-rds-vpc" }
}

resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.0.1.0/24"
  #availability_zone = data.aws_availability_zones.available.names[0]
  availability_zone = "ca-central-1a"

  tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.0.2.0/24"
  #availability_zone = data.aws_availability_zones.available.names[1]
  availability_zone = "ca-central-1b"

  tags = { Name = "private-subnet-2" }
}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

# ==========================================
# 2. SECURITY GROUPS
# ==========================================

# Lambda Security Group
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-sg"
  description = "Security Group for Lambda Function"
  vpc_id      = aws_vpc.main.id
# ingress = {
#     from_port = 0
#     to_port = 0
#     protocol = "-1"
#     codr_blocks = "0.0.0.0/0"
# }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Security Group (MySQL Port 3306)
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow inbound MySQL traffic from Lambda only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306 
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }
}

# Secrets Manager VPC Endpoint Security Group
resource "aws_security_group" "vpce_sg" {
  name        = "secretsmanager-vpce-sg"
  description = "Allow HTTPS inbound from Lambda"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }
}


# ==========================================
# 3. AWS SECRETS MANAGER & VPC ENDPOINT
# ==========================================

# Secret definition
resource "aws_secretsmanager_secret" "db_secret" {
  name                    = "secure-database-credentials"
  recovery_window_in_days = 0 
}

# Values match the actual MySQL database settings below
resource "aws_secretsmanager_secret_version" "db_secret_val" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "Cloud123" 
  })
}

# VPC Endpoint for Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  #service_name        = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  service_name         = "com.amazonaws.ca-central-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  security_group_ids = [aws_security_group.vpce_sg.id]

  tags = { Name = "secretsmanager-endpoint" }
}

data "aws_region" "current" {}

# ==========================================
# 4. AMAZON RDS INSTANCE (MYSQL FREE TIER)
# ==========================================

resource "aws_db_instance" "mysql" {
  identifier             = "private-mysql-db"
  allocated_storage      = 20                  # Free Tier supports up to 20 GB of SSD Storage
  engine                 = "mysql"
  engine_version         = "8.0"               # Standard MySQL 8.0 engine
  instance_class         = "db.t3.micro"       # Free Tier eligible instance type
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  
  username               = "admin"
  password               = "Password123"
  
  skip_final_snapshot    = true
  publicly_accessible    = false
}

# ==========================================
# 5. AWS LAMBDA FUNCTION & DATABASE LAYER
# ==========================================

resource "aws_iam_role" "lambda_role" {
  name = "lambda-vpc-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}
