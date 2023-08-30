resource "null_resource" "create_db_admin" {
  triggers = {
    ops_user = var.ops_user
  }

  provisioner "local-exec" {
    command     = "chmod +x ../scripts/ops_user.sh && ../scripts/ops_user.sh ${aws_redshift_cluster.redshift_cluster.id} ${var.rs_database_name} ${var.ops_user} ${var.redshift_user} ${var.redshift_password} ${var.workspace_name}"
    interpreter = ["bash", "-c"]
  }

  depends_on = [aws_redshift_cluster.redshift_cluster]
}
