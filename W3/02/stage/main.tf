cat <<EOT > main.tf
resource "aws_db_subnet_group" "beas-dbsubnet" {
  name       = "mydbsubnetgroup"
  subnet_ids = [aws_subnet.beas-subnet3.id, aws_subnet.beas-subnet4.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "beas-rds" {
  identifier_prefix      = "t101"
  engine                 = "mysql"
  allocated_storage      = 10
  instance_class         = "db.t2.micro"
  db_subnet_group_name   = aws_db_subnet_group.beas-dbsubnet.name
  vpc_security_group_ids = [aws_security_group.beas-sg2.id]
  skip_final_snapshot    = true

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
}
EOT