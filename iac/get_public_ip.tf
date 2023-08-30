data "external" "public_ip" {
  program = ["bash", "-c", <<-EOF
    result=$(aws redshift describe-clusters --cluster-identifier "${aws_redshift_cluster.redshift_cluster.id}" --query "Clusters[0].ClusterNodes[0].PublicIPAddress" --output text)
    echo "{ \"public_ip\": \"$result\" }"
  EOF
  ]
}