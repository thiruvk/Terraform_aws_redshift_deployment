
locals {
  // project_id = element(split("/", var.gitlab_pipeline_url), 6)
  s3_source_region = length(data.aws_region.current.name) > 0 ? data.aws_region.current.name : "us-east-2"
  mapping_regions_table_s3_replication = {
   "us-east-1"      = "us-east-2",
   "us-east-2"      = "us-east-1",
   "us-west-1"      = "us-west-2",
   "us-west-2"      = "us-west-1",
   "ap-south-1"     = "ap-northeast-2",
   "ap-northeast-1" = "ap-northeast-2",
   "ap-northeast-2" = "ap-northeast-1",
   "ap-southeast-1" = "ap-southeast-2",
   "ap-southeast-2" = "ap-southeast-1"
   "ca-central-1"   = "us-west-2",
   "cn-northwest-1" = "cn-north-1",
   "cn-north-1"     = "cn-northwest-1",
   "eu-central-1"   = "eu-west-1",
   "eu-west-1"      = "eu-central-1",
   "eu-west-2"      = "eu-west-1",
   "sa-east-1"      = "sa-east-1",
   "us-gov-west-1"  = "us-gov-west-1"
  }

  s3_destination_region = length(local.s3_source_region) > 0 ? lookup(local.mapping_regions_table_s3_replication, local.s3_source_region) : "us-east-2"


  // lifecycle = length(var.environment_type) > 0 ? var.environment_type : try(data.terraform_remote_state.platform.outputs.lifecycle, null)

 
//  ip-filtering        = join("\",\"", data.terraform_remote_state.platform.outputs.ip-filtering-ranges)
//  ip-filtering-ranges = "\"${local.ip-filtering}\""

 // split-connect-provider = split("/", data.terraform_remote_state.platform.outputs.my-eks-iamopenid-connect-provider)
 // connect-provider-id    = element(local.split-connect-provider, length(local.split-connect-provider) - 1)
   
}
