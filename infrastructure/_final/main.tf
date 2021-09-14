/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Nora Schöner & Sandra Gerberding
  
  This file defines used providers, their versions and the
  terraform backend.
  
  Maintainer:   @norchen, @smily75
  Created:      2021-08-01
  Last Updated: 2021-09-12
--------------------------------------------------------------*/


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

# default subnet a
resource "aws_default_subnet" "default_az1" {
  availability_zone = "${var.region}a"

  tags = {
    Name = "Default subnet for ${var.region}a"
  }
}

# default subnet b
resource "aws_default_subnet" "default_az2" {
  availability_zone = "${var.region}b"

  tags = {
    Name = "Default subnet for ${var.region}b"
  }
}

/*--------------------------------------------------------------
  EC2 - Server Instance
--------------------------------------------------------------*/
/*--------------------------------------------------------------
  Amazon Linux 2 AMI (Amazon Machine Image)
  💡 This is the AMI which will be used for the EC2 unstance.
     To use the t4g.micro instance a ARM64 AMI is needed.
--------------------------------------------------------------*/
data "aws_ami" "amazon_linux_2_arm64" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }
}

# ---------------------------------------------------
# EC2 Instance
# ---------------------------------------------------
resource "aws_instance" "server" {
  ami           = data.aws_ami.amazon_linux_2_arm64.image_id
  instance_type = "t4g.micro"
  disable_api_termination = false

  vpc_security_group_ids = [aws_security_group.server.id]
  # to be in same availability zone as loadbalncer
  subnet_id = aws_default_subnet.default_az1.id
  associate_public_ip_address = true

  # ignore changes when a new aws ami version is chosen
  lifecycle {
    ignore_changes = [ami]
  }
}

/*--------------------------------------------------------------
 EC2: Key Pair (optional)
--------------------------------------------------------------*/
# resource "aws_key_pair" "server" {
#   key_name   = join("-", [local.resource_prefix, "server"])
#   public_key = var.ec2_key_pair_public_key
# }

/*--------------------------------------------------------------
 EC2: Security Group
--------------------------------------------------------------*/
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
  # TODO: Von welchem Port aus greift der Loadbalancer drauf zu?
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.loadbalancer.id]
  }
}

/*--------------------------------------------------------------
  RDS - Database Instance
--------------------------------------------------------------*/
/*--------------------------------------------------------------
  MySQL RDS
    - only used for TK at the moment 
--------------------------------------------------------------*/
/* ✨ [OPTIONAL] 
   If you want to use a simple (secret) password setup for
   your DB you can use SSM Parameters and Terraform's random generator.
*/
resource "random_password" "database_password" {
  length  = 16
  special = true
}

resource "aws_ssm_parameter" "database_password" {
  name        = join("/", ["", var.project, var.stage, "database", "password"])
  description = "password for my database"
  type        = "SecureString"
  value       = random_password.database_password.result
}

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

# common RDS instance with latest MySQL
resource "aws_db_instance" "database" {
  identifier              = join("-", [local.resource_prefix, "database"])
  multi_az                = false
  allocated_storage       = local.rds_instance_allocated_storage
  engine                  = "mysql"
  engine_version          = "8.0.23"
  parameter_group_name    = "default.mysql8.0"
  instance_class          = local.rds_instance_class
  name                    = local.rds_database_name
  username                = local.rds_database_user_name
  password                = random_password.database_password.result
  port                    = 3306
  skip_final_snapshot     = true
  backup_retention_period = local.rds_database_backup_retetion_period
  copy_tags_to_snapshot   = true
  apply_immediately       = true
  vpc_security_group_ids = [aws_security_group.database.id]
}

/*--------------------------------------------------------------
  Loadbalancer
--------------------------------------------------------------*/
resource "aws_security_group" "loadbalancer" {
  name        = join("-", [local.resource_prefix, "lb"])
  description = "loadbalancer for my server"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "loadbalancer" {
  name               = join("-", [local.resource_prefix, "lb"])
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer.id]
  subnets = [
    aws_default_subnet.default_az1.id,
    aws_default_subnet.default_az2.id
  ]
}

resource "aws_lb_listener" "server" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.server.arn
  }
}

resource "aws_lb_target_group" "server" {
  name     = join("-", [local.resource_prefix, "server"])
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id

  health_check {
    enabled = true
    path = "/actuator/health"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "server" {
  target_group_arn = aws_lb_target_group.server.arn
  target_id        = aws_instance.server.id
  port             = 80
}