provider "aws" {
  region = "us-east-2"
}

# Creating EC2 instance
module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "w2d-server02"
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