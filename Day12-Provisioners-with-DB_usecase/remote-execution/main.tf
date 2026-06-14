

# Key Pair
resource "aws_key_pair" "remote" {
  key_name   = "remotekp"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "aws_instance" "sql_runner" {
  ami                    = "ami-06445ac85e0d277a9" # Amazon Linux 2
  instance_type          = "t3.micro"
  key_name               = "remotekp"                # Replace with your key pair name
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet1.id
  vpc_security_group_ids = [aws_security_group.mysg.id]

  tags = {
    Name = "SQL Runner"
  }
}


resource "aws_vpc" "myvpc" {
  cidr_block = "192.0.0.0/16"
}
resource "aws_internet_gateway" "myig" {
  vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "Dev-igw"
    }
}
#creation of route table
resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "Dev-rt"
    }
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.myig.id
    }
}
#association of route table with public subnet
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.myrt.id
}


resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "192.0.1.0/24"
  availability_zone = "ca-central-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = "192.0.2.0/24"
  availability_zone = "ca-central-1b"
}

resource "aws_db_subnet_group" "name" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_security_group" "mysg" {
  name        = "my-db-security-group"
  description = "Allow MySQL traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
resource "aws_db_instance" "name" {
  identifier             = "my-rds-instance"
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  db_subnet_group_name   = aws_db_subnet_group.name.name
  vpc_security_group_ids = [aws_security_group.mysg.id]
  skip_final_snapshot    = true
  username               = "admin"
  password               = "Cloud123"
  #managed_master_user_password = true #enable password management by AWS Secrets Manager
  maintenance_window     = "Mon:00:00-Mon:03:00"
  backup_window          = "03:00-06:00"


}


# Deploy SQL remotely using null_resource + remote-exec
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.name, aws_instance.sql_runner]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")   # Replace with your PEM file path
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "remotescript.sql"
    destination = "/tmp/remotescript.sql"
  }

 provisioner "remote-exec" {
  inline = [
    "sudo yum update -y",
    "sudo yum install -y mariadb105",
    "mysql --version",

    "mysql -h ${aws_db_instance.name.address} -u admin -p'Cloud123' < /tmp/remotescript.sql"
  ]
}

  triggers = {
    always_run = timestamp() #trigger every time apply 
  }
}




# ADD RDS creation script only accessbale interanlly si disable public access 
# Remote provisioner server also should create insame vpc 
# enable secrets fro secret manager and call secrets into RDS for this process vpc endpoint is require or nat gateway is required to access secrets to rds internall as secremanger is not in side VPC sefrvice 