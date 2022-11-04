# Define AWS Provider #######################################
# It automatically takes the credentials from
# "~/.aws/credentials" for profile "okta-elastic-dev"
provider "aws" {
  region                   = "us-east-2"
  profile                  = "okta-elastic-dev"
}

terraform {
  backend "s3" {
    bucket         = "ernesto-reig-terraform-st"
    key            = "stage/data-stores/mysql/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "ernesto-reig-tf-"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}