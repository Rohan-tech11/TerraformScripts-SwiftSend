resource "aws_db_subnet_group" "default" {
  name       = "${var.environment}-rds-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name = "${var.environment}-rds-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.environment}-rds-sg"
  description = "Allow inbound traffic to RDS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow MySQL traffic from anywhere"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-rds-sg"
  }
}

resource "aws_db_instance" "default" {
  identifier           = "${var.environment}-mysql-instance"
  engine               = "mysql"
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
    publicly_accessible    = true  # Add this line to make it publicly accessible


  tags = {
    Name = "${var.environment}-mysql-instance"
  }
}