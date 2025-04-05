data "aws_secretsmanager_secret" "db_secret" {
  name = "prod-db-password"
  depends_on = [ aws_secretsmanager_secret.db_secret ]
}

data "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
#   depends_on = [  ]
}

resource "aws_db_subnet_group" "prod_subnet_group" {
  name       = "prod-db-subnet-group"
  subnet_ids = [aws_subnet.public-subnet-1.id]
  tags = {
    name = "prod db subnet group"
  }

}

resource "aws_db_instance" "prod_db_instance" {
  allocated_storage    = 10
  db_name              = "prod_db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = data.aws_secretsmanager_secret_version.db_secret_version.secret_string
  publicly_accessible  = true
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
}