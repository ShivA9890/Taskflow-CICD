resource "aws_db_subnet_group" "database_subnet" {
    name = "taskflow_subnet"
    subnet_ids = module.vpc.private_subnets

    tags = {
      Name = "Taskflow-Database-subnet"
    }
  
}

resource "aws_db_instance" "taskflow" {
  identifier     = "taskflowdb"
  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"

  db_name  = "taskflow"
  username = "taskflow_admin"
  password = random_password.db_password.result

  db_subnet_group_name   = aws_db_subnet_group.database_subnet.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = false

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Project     = "Taskflow"
    environment = "practice"
  }

}