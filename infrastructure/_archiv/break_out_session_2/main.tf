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

  rds_instance_allocated_storage      = var.stage == "dev" ? 5 : 10
  rds_instance_class                  = var.stage == "dev" ? "db.t3.micro" : "db.t3.micro"
  rds_database_name                   = var.stage == "dev" ? "worshopdbdev" : "workshopdbprod"
  rds_database_user_name              = "dbuser"
  rds_database_backup_retetion_period = 14
  rds_database_deletion_protection    = var.stage == "dev" ? false : true
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
  ami           = "ami-0d527b8c289b4af7f"
  instance_type = "t2.micro"

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

  # to access application from the internet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*--------------------------------------------------------------
  Database
--------------------------------------------------------------*/

resource "aws_security_group" "database" {
  name        = join("-", [local.resource_prefix, "database"])
  description = "security group for maintaining access to the database"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.server.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "random_password" "database_password" {
  length  = 16
  special = true
}

# encryption of database through AWS KMS
resource "aws_kms_key" "database" {
  description = "KMS key for my database"
}
# common RDS instance with latest MySQL
resource "aws_db_instance" "database" {
  identifier              = join("-", [local.resource_prefix, "database"])
  multi_az                = false
  allocated_storage       = local.rds_instance_allocated_storage
  engine                  = "mysql"
  engine_version          = "8.0.23"
  parameter_group_name    = "default.mysql8.0"
  instance_class          = local.rds_instance_class
  db_name                 = local.rds_database_name
  username                = local.rds_database_user_name
  password                = random_password.database_password.result
  port                    = 3306
  skip_final_snapshot     = true
  backup_retention_period = local.rds_database_backup_retetion_period
  copy_tags_to_snapshot   = true
  apply_immediately       = true
  vpc_security_group_ids = [aws_security_group.database.id]

  # encryption
  storage_encrypted   = true
  kms_key_id          = aws_kms_key.database.arn
}