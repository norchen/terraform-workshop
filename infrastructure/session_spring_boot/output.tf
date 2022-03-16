/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Nora Schöner & Sandra Gerberding
  
  This file defines used providers, their versions and the
  terraform backend.
  
  Maintainer:   @norchen, @smily75
  Created:      2021-08-01
  Last Updated: 2021-09-12
--------------------------------------------------------------*/

output "ec2_instance_public_ip" {
  value = aws_instance.server.public_ip
}

/* output "rds_endpoint" {
  value = aws_db_instance.database.address
}

output "loadbalancer_public_dns" {
  value = aws_lb.loadbalancer.dns_name
} */