/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Sandra Gerberding & Nora Schöner
  
  This file defines used providers, their versions and the
  terraform backend.
  
  Maintainer:   @smily75, @norchen
  Created:      2021-08-01
  Last Updated: 2021-08-01
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
# get all available availability zones of the region
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# TODO: check for need => but fun because of for_each 
resource "aws_default_subnet" "default" {
  for_each = data.aws_availability_zones.available[*]
  availability_zone = each.value.name

  tags = {
    Name = "Default subnet for ${each.value.name}"
  }
}

/*--------------------------------------------------------------
  EC2 - Server Instance

--------------------------------------------------------------*/

/*--------------------------------------------------------------
  RDS - Database Instance

--------------------------------------------------------------*/