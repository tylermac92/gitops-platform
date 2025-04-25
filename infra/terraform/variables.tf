variable "region" { default = "us-east-1" }
variable "cluster_name" { default = "gitops-eks" }
variable "k8s_version" { default = "1.26" }
variable "node_count" { default = 2 }
variable "instance_type" { default = "t3.medium" }
variable "argo_cd_chart_version" { default = "7.8.27" }
variable "argo_cd_version" { default = "v2.12.12" }
