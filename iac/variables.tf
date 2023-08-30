variable "CostDimsEnvTag" {
  default = ""
}

variable "CostDimsShared" {
  default = ""
}

variable "CostDimsContractTag" {
  default = ""
}

variable "CostDims" {
  default = ""
}

variable "type_env"  {
  default = ""
}

variable "product_tag" {
  default = ""
}

variable "costcenter_tag" {
  default = ""
}

variable "workspace_name" {
  default = ""
}

variable "aws_region" { 
  default = ""
}

variable "gitlab_pipeline_url" {
  default = ""
}

variable "rs_vpc_cidr" { 
  default = ""
}

variable "rs_database_name" { 
  default = ""
}

variable "redshift_user" { 
  default = ""
}

variable "redshift_password" { 
  default = ""
}

variable "rs_nodetype" { 
  default = ""
}

variable "aws_access_key_id" {
  default = ""
}

variable "ip_ingress_ranges" {
  type = list(tuple([string, string]))
  default = []
}

variable "ip_egress_ranges" {
  type = list(tuple([string, string]))
  default = []
}

variable "maintenance_window" {
  default     = ""
}

variable "snapshot_identifier" {
  default     = ""
}

variable "multi_az" {
  type        = bool
  default     = false
}

variable "snapshot_retention_period" {
  default     = ""
}

variable "node_count" {
  default = "1"
}

variable "ops_user" {
  default = ""
}
