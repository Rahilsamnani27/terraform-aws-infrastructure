# --- Subnet group: tells RDS which (private) subnets it's allowed to live in ---
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "postgres"
  engine_version = "16.10"

  instance_class    = var.db_instance_class
  allocated_storage = 20 # GB — within RDS free-tier allowance
  storage_type      = "gp2"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible = false # only reachable from inside the VPC (web tier)
  multi_az            = false # single-AZ keeps this within free-tier cost

  skip_final_snapshot = true # simplifies `terraform destroy` for a demo project
  deletion_protection = false

  tags = {
    Name = "${var.project_name}-db"
  }
}
