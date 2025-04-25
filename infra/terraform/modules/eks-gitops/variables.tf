variable "region" { type = string }
variable "cluster_name" { type = string }
variable "k8s_version" { type = string }
variable "node_count" { type = number }
variable "instance_type" { type = string }
variable "argo_cd_chart_version" { type = string }
variable "argo_cd_version" { type = string }

variable "vpc_id" {
  description = "ID of the VPC in which to create the EKS cluster"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs (private subnets recommended) where worker nodes will live"
  type        = list(string)
}
