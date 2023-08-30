

## Redshift Cluster - Output ##

output "redshift_cluster_id" {
  value       = aws_redshift_cluster.redshift_cluster.id
}

## Redshift Cluster Endpoint - Output ##
output "redshift_endpoint" {
  value       = aws_redshift_cluster.redshift_cluster.endpoint
  description = "The endpoint of the Redshift cluster"
}

## Redshift Cluster JDBC URL - Output ##
output "jdbc_url" {
  value       = "jdbc:redshift://${aws_redshift_cluster.redshift_cluster.endpoint}/${var.rs_database_name}"
  description = "The JDBC URL for connecting to the Redshift cluster"
}

## Redshift Cluster Public IP - Output ##
output "public_ip_address" {
  value = data.external.public_ip.result["public_ip"]
}




