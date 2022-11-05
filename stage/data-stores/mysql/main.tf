terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
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

provider "aws" {
  region = "us-east-2"
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_name     = "stage_db"
  db_username = var.db_username
  db_password = var.db_password

  # Must be enabled to support replication
  # Disabled as we don´t need replication in STAGE environment
  # backup_retention_period = 1
}