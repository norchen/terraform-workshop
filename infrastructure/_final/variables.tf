/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Sandra Gerberding & Nora Schöner
  
  This file defines used providers, their versions and the
  terraform backend.
  
  Maintainer:   @smily75, @norchen
  Created:      2021-08-01
  Last Updated: 2021-08-01
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