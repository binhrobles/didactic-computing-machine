resource "aws_db_instance" "postgres" {
  allocated_storage   = 20
  instance_class      = "db.t2.micro"
  engine              = "postgres"
  username            = var.db_user
  password            = var.db_password
  skip_final_snapshot = true
}

resource "aws_security_group" "postgres" {
  name_prefix = "postgres"
  description = "Postgres security group"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eb_sg_id]
  }
}
