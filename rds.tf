provider "aws" {
  region = "us-east-2"
}

# Creating RDS SQL Instance
# Default provider configuration
#
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-ex"
  engine_version       = "15.00"  # Updated to a supported version
  instance_class       = "db.t3.micro"
  identifier           = "w2d-dbsql02"
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  multi_az             = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "db_username" {
  type        = string
  description = "The username for the RDS instance"
}

variable "db_password" {
  type        = string
  description = "The password for the RDS instance"
  sensitive   = true
}