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
  
  For every provider a 'provider' resource have to be created.
  If you need to specify multiple 'provider' resources of the 
  same provider, you have to work with aliases. 
  Otherweise aliases are optional. 
--------------------------------------------------------------*/

# set provider
provider "aws" {
  region  = var.region
  profile = "devops-tools-non-prod"

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

# example for a provider of another AWS region
# provider "aws" {
#   alias  = "eu-central-1"
#   region = "eu-central-1"
# }


/*--------------------------------------------------------------
  VERSIONS & BACKEND

  Using `terraform{}` you can specify how Terraform should behave.
  You can:
    * set the Terraform version
    * set a specific version for every provider
    * add a backend configuration for remote state management

  Common operators for versions:
  =   using the exact version
  >=  using the version set or latest if available
  ~>  using the rightmost version; use to allow minor patches

  💡 Tip for procudtion: Version pinning is always a good choice 
     to stay on top of your dependency game! This prevents nasty 
     surprises e.g. because a breaking change was introduced in 
     a specific provider version. 
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
  required_version = ">= 1.0.0 "

  # remote state configuration; if nothing is specified local state is used by default 
  #  backend "s3" {
  #   bucket = "terraform-state-bucket"
  #   key    = "path/to/my/key.tfstate"
  #   region = "eu-central-1"
  # }
}
