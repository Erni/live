# Define AWS Provider #######################################
# It automatically takes the credentials from
# "~/.aws/credentials" for profile "okta-elastic-dev"
provider "aws" {
  region                   = "us-east-2"
  profile                  = "okta-elastic-dev"
}

# Reference to this module to make it accessible to this environment
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster" # this can also be a url

  cluster_name           = var.cluster_name
  # commenting this parameter so it is the same bucket name in all environments
  # db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}

# we expand the the SG rule for testing purposes just in this environment
resource "aws_security_group_rule" "allow_testing_inbound" {
  type = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = [0.0.0.0/0]
}