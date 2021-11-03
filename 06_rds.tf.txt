resource "aws_db_instance" "jwcho_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_type
  name                   = "wordpress"
  identifier             = "mydb"
  username               = "master"
  password               = "It123412341!"
  parameter_group_name   = "default.mysql8.0"
  availability_zone      = "${var.region}${var.avazone[0]}"
  vpc_security_group_ids = [aws_security_group.jwcho_websg.id]
  db_subnet_group_name   = aws_db_subnet_group.jwcho_db_sb_group.id
  skip_final_snapshot    = true
  tags = {
    "Name" = "mydb"
  }
}


resource "aws_db_subnet_group" "jwcho_db_sb_group" {
  name       = "${var.name}-db-subnet"
  subnet_ids = [aws_subnet.jwcho_db[0].id, aws_subnet.jwcho_db[1].id]

  tags = {
    "Name" = "${var.name}-db-sb-group"
  }
}
