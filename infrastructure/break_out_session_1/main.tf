/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Nora Schöner & Sandra Gerberding
  
  This file defines used providers, their versions and the
  terraform backend.
  
  Maintainer:   @norchen, @smily75
  Created:      2021-08-01
  Last Updated: 2021-09-12
--------------------------------------------------------------*/
/*--------------------------------------------------------------
  PROVIDER
--------------------------------------------------------------*/
provider "aws" {
  region  = var.region
  profile = "your-aws-profile"

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
  VARIABLES
--------------------------------------------------------------*/
variable "region" {
  type        = string
  description = "the region used for the (main) provider"
}

variable "project" {
  type        = string
  description = "the name of the project the resources are associated to"
}

variable "stage" {
  type        = string
  description = "the name of the environment aka stage the resources are associated to"
}

/*--------------------------------------------------------------
  LOCALS
--------------------------------------------------------------*/
locals {
  resource_prefix = join("-", [var.project, var.stage])
}

/*--------------------------------------------------------------
  NETWORK

  For a simple intro to Terraform & AWS the default network is
  used. All resources beginning with 'aws_default_*' won't be
  created. They are used for reference in other resources.

  This includes:
  * a VPC 
  * subnets
--------------------------------------------------------------*/
# default AWS VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

/*--------------------------------------------------------------
  EC2
--------------------------------------------------------------*/
# server instance
resource "aws_instance" "server" {
  ami           = "ami-029c64b3c205e6cce"
  instance_type = "t4g.micro"

  vpc_security_group_ids = [aws_security_group.server.id]
  associate_public_ip_address = true
}

#security group
resource "aws_security_group" "server" {
  name        = join("-", [local.resource_prefix, "server"])
  description = "security group for managing access for my server"
  vpc_id      = aws_default_vpc.default.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # set to your personal IP
  }
}