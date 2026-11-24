resource "aws_db_subnet_group" "db" {
  name       = "td2-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
}

resource "random_password" "db_password" {
  length  = 16
  special = false
}

resource "aws_db_instance" "db" {
  identifier           = "td2-db-instance"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  db_name              = "td2db"
  username             = "admin"
  password             = random_password.db_password.result
  db_subnet_group_name = aws_db_subnet_group.db.name
  publicly_accessible  = false
  skip_final_snapshot  = true
}
