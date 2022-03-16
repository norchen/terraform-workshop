/*--------------------------------------------------------------
 VERSION PINNING
--------------------------------------------------------------*/
terraform {
  required_providers {

    # sets version for AWS Terraform provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.4.0"
    }
  }

  # sets Terraform version
  required_version = ">= 1.0.0"
}

/*--------------------------------------------------------------
 PROVIDER
--------------------------------------------------------------*/
provider "aws" {
  region  = var.region
  profile = "workshop-test"

  # these tags will be used for every ressource
  default_tags {
    tags = {
      Environment = var.stage
      Owner       = "My Name"
      Project     = var.project
      Name        = local.resource_prefix
    }
  }
}

/*--------------------------------------------------------------
 VARIABLES & LOCALS
--------------------------------------------------------------*/
variable "region" {}
variable "project" {}
variable "stage" {}

locals { 
  resource_prefix = join("-", [var.project, var.stage])
}

/*--------------------------------------------------------------
 SOME RESOURCES
--------------------------------------------------------------*/
data "aws_ami" "amazon_linux_2_x86_64" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["*ubuntu-focal-20.04*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "server_remote_state" {
  ami           = data.aws_ami.amazon_linux_2_x86_64.image_id
  instance_type = "t2.micro"
  disable_api_termination = false
  associate_public_ip_address = true
  # ignore changes when a new aws ami version is chosen
  lifecycle {
    ignore_changes = [ami]
  }
}