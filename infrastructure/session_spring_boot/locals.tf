/*--------------------------------------------------------------
  TERRAFORM WORKSHOP by Nora Schöner & Sandra Gerberding
  
  This file defines used providers, their versions and the
  terraform backend.
  
  Maintainer:   @norchen, @smily75
  Created:      2021-08-01
  Last Updated: 2021-09-12
--------------------------------------------------------------*/


/*--------------------------------------------------------------
  LOCALS

  Locals help you to locally create und and use contant values. 
  For instance, they can be used to building a configuration 
  file for your setup.
--------------------------------------------------------------*/
locals {
  resource_prefix                      = join("-", [var.project, substr(var.stage, 0, 4)])
  spring_boot_project_stage_identifier = join("_", [var.project, var.stage])

  /*--------------------------------------------------------------
    RDS (database)
  --------------------------------------------------------------*/
  rds_instance_allocated_storage      = var.stage == "dev" ? 5 : 10
  rds_instance_class                  = var.stage == "dev" ? "db.t3.micro" : "db.t3.micro"
  rds_database_name                   = var.stage == "dev" ? "workshopdbdev" : "workshopdbprod"
  rds_database_user_name              = "dbuser"
  rds_database_backup_retetion_period = 14
  rds_database_deletion_protection    = var.stage == "dev" ? false : true
}