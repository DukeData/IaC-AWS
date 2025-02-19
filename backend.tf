terraform {
  backend "s3" {
    bucket         = "iac-s3-bucket"
    region         = "us-east-2"
    key            = "s3-github-actions/terraform.tfstate"
    encrypt = true
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source = "hashicorp/aws"
    }
  }
}

# this backend configuration is for storing the terraform state file in S3 bucket
# the bucket name is iac-s3-bucket
# the region is us-east-2
# the key is s3-github-actions/terraform.tfstate
# the state file will be encrypted  
# its the manaul process and step 1 of the process.