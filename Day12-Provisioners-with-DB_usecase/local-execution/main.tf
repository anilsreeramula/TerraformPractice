# Create the RDS instance
resource "aws_db_instance" "mysql_rds" {
  identifier          = "mylocalsqldb"
  engine              = "mysql"
  engine_version      = "8.0"
  instance_class      = "db.t3.micro"
  username            = "admin"
  password            = "Cloud123"
  db_name             = "mylocaldb"
  allocated_storage   = 20
  skip_final_snapshot = true
  publicly_accessible = true
}

# Execute SQL script from local machine
resource "null_resource" "local_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds]

  provisioner "local-exec" {
    command = <<-EOT
      mysql -h ${aws_db_instance.mysql_rds.address} -u admin -pCloud123 mylocaldb < test.sql
    EOT
  }

  triggers = {
    always_run = timestamp()
  }
}