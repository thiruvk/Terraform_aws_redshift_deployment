resource "aws_redshift_cluster" "redshift_cluster" {
  cluster_identifier               = var.workspace_name
  database_name                    = var.rs_database_name
  master_username                  = var.redshift_user
  master_password                  = var.redshift_password
  node_type                        = var.rs_nodetype
  number_of_nodes                  = var.node_count
  cluster_subnet_group_name        = aws_redshift_subnet_group.redshift_subnet_group.id
  cluster_parameter_group_name     = var.workspace_name
  publicly_accessible              = true
  skip_final_snapshot              = true
  automated_snapshot_retention_period = var.snapshot_retention_period
  snapshot_identifier              = var.snapshot_identifier
  encrypted                        = true
  preferred_maintenance_window     = var.maintenance_window

  availability_zone                = var.multi_az ? data.aws_availability_zones.available.names[0] : null

  depends_on = [
    aws_vpc.redshift_vpc,
    aws_default_security_group.redshift_security_group,
    aws_redshift_subnet_group.redshift_subnet_group,
    aws_redshift_parameter_group.redshift_parameter_group,
  ]
}
