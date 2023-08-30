
#############################
# Configure the AWS Provider
#############################

terraform {
   required_providers {
       aws = {
         source  = "hashicorp/aws"
         version = "3.65.0"
       }
       local = {
         version = "2.1.0"
       }
       null = {
         version = "3.1.0"
       }
       random = {
         version = "3.4.3"
       }
       time = {
         version = "0.9.1"
       }
       gitlab = {
          source = "gitlabhq/gitlab"
          version = "3.20.0"
       }
   }

}

terraform {
  backend "http" {
  }
}

provider "aws" {
   alias      = "destination"
   region     = local.s3_destination_region
   access_key = var.aws_access_key_id
   secret_key = "<GITOPS_AWS_SECRET_ACCESS_KEY>"
 }

provider "gitlab" {
  base_url  = var.ci_api_v4_url
  token    = var.gitlab_personal_access_token
}

provider "aws" {
  region     = "<GITOPS_AWS_REGION>"
  access_key = var.aws_access_key_id
  secret_key = "<GITOPS_AWS_SECRET_ACCESS_KEY>"
   default_tags {
    tags = {
      platform    = var.workspace_name
      Product     = var.product_tag
      CostCenter  = var.costcenter_tag
      Lifecycle   = var.type_env 
      CostDims    = "${var.CostDimsEnvTag} ${var.CostDimsContractTag} pr:${var.product_tag}"
    }
  }
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}
