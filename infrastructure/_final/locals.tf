locals {
  resource_prefix = join("-", [var.project, var.stage])

  /*--------------------------------------------------------------
    RDS (database)
  --------------------------------------------------------------*/
  rds_instance_allocated_storage      = var.stage == "dev" ? 5 : 10
  rds_instance_class                  = var.stage == "dev" ? "db.t3.micro" : "db.t3.micro"
  rds_database_name                   = var.stage == "dev" ? "herbstcampusdbdev" : "herbstcampusdbprod"
  rds_database_user_name              = "dbuser"
  rds_database_backup_retetion_period = 14
  rds_database_deletion_protection    = var.stage == "dev" ? false : true
}