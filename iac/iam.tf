# Define the IAM user and policy
resource "aws_iam_user" "redshift_share_user" {
  name = "redshift_share_user_${var.workspace_name}"
}

resource "aws_iam_access_key" "redshift_share_access_key" {
  user = aws_iam_user.redshift_share_user.name
}

data "aws_iam_policy_document" "redshift_share_policy" {
  depends_on = [aws_redshift_cluster.redshift_cluster]

  statement {
    actions   = [
      "redshift:PauseCluster",
      "redshift:ResumeCluster",
      "redshift:CreateClusterSnapshot",
      "redshift:DescribeClusters"
    ]
    resources = [
      "arn:aws:redshift:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:cluster:${aws_redshift_cluster.redshift_cluster.cluster_identifier}"
    ]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "redshift_share_policy" {
  name   = "redshift_share_policy_${var.workspace_name}"
  policy = data.aws_iam_policy_document.redshift_share_policy.json
}

resource "aws_iam_user_policy_attachment" "redshift_share_policy_attachment" {
  user       = aws_iam_user.redshift_share_user.name
  policy_arn = aws_iam_policy.redshift_share_policy.arn
}

#
resource "null_resource" "update_secret" {
  provisioner "local-exec" {
    command = <<-EOT
      existing_secret=$(aws secretsmanager get-secret-value --secret-id "${var.workspace_name}" --query SecretString --output text)
      updated_secret=$(jq -n --argjson existing_secret "$existing_secret" --arg access_key "${aws_iam_access_key.redshift_share_access_key.id}" --arg secret_key "${aws_iam_access_key.redshift_share_access_key.secret}" '$existing_secret + {"REDSHIFT_PAUSE_RESUME_USER_ID": $access_key, "REDSHIFT_PAUSE_RESUME_USER_SECRET_KEY": $secret_key}')
      aws secretsmanager update-secret --secret-id "${var.workspace_name}" --secret-string "$updated_secret"
    EOT
  }

  depends_on = [aws_iam_access_key.redshift_share_access_key]
}
