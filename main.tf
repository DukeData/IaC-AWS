provider "aws" {
  region = "us-east-2"
}

#tfsec:ignore:aws-s3-enable-bucket-logging
resource "aws_s3_bucket" "example" {
  bucket = "iac-aws-gitactions-kannan"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.example.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]

  bucket = aws_s3_bucket.example.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Creating EC2 instance
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "w2d-server01"
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  #key_name               = "user1" - Uncomment this line to use your own key pair
  monitoring             = true
  #vpc_security_group_ids = ["sg-12345678"]
  #subnet_id              = "subnet-eddcdzz4"
  version = "4.0.0" 

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# Creating RDS SQL Instance
# Default provider configuration
provider "aws" {
  region = "us-east-1"
}

# Aliased provider configuration (if needed)
provider "aws" {
  alias  = "secondary"
  region = "us-west-2"
}

# Using the default provider
resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "sqlserver-se"
  engine_version       = "14.00.3035.2.v1"
  instance_class       = "db.t3.medium"
  name                 = "W2D-RDSSQL01"
  username             = var.db_username
  password             = var.db_password
  publicly_accessible  = false
  multi_az             = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


