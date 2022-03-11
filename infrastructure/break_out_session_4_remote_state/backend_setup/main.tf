/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Nora Schöner & Sandra Gerberding
  
  This file defines the basic setup for our Terraform S3 backend.
  
  Maintainer:   @norchen, @smily75
--------------------------------------------------------------*/

/*--------------------------------------------------------------
 VERSION PINNING
--------------------------------------------------------------*/
terraform {
  required_providers {

    # sets version for AWS Terraform provider
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.49.0"
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
 STATE BUCKET
--------------------------------------------------------------*/
resource "aws_s3_bucket" "terraform_state_s3_bucket" {
  bucket = join("-", [local.resource_prefix, "terraform-statefiles", var.region])

  # to version every change to the state
  # in case of an error or unwanted change in your state 
  # you can role back to e former state version
  versioning {
    enabled = true
  }

  # the state shouldn't be destroyed
  lifecycle {
    prevent_destroy = true
  }
}

/*--------------------------------------------------------------
 STATE LOCK DYNAMO TABLE
--------------------------------------------------------------*/
resource "aws_dynamodb_table" "terraform_state_locking_dynamodb" {
  name         = join("-", [local.resource_prefix, "terraform-state-locking"])
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }
}
