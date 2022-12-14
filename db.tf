resource "aws_db_instance" "rds_petclinic" {
  allocated_storage = 20
  max_allocated_storage = 0
  identifier = "mysql-${var.prefix}-${var.environment}-${var.db_identifier}"
  db_name = "${var.db_name}"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "${var.db_instance_class}"
  storage_type = "${var.db_storage_type}"
  username = "${var.db_username}"
  password = "${var.db_password}"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  tags = {
    Name = "${var.prefix}-${var.environment}-petclinic-rds"
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name = "rds-subnets"
  subnet_ids = "${data.aws_subnets.subnets.ids}"
}

resource "aws_security_group" "rds_sg" {
  name = "${var.prefix}-${var.environment}-allow-sql"
  description = "security group for rds"
  vpc_id = aws_default_vpc.default.id

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    security_groups = ["${aws_security_group.instance_sg.id}"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}