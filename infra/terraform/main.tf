module "eks_github" {
  source                = "./modules/eks-gitops"
  region                = var.region
  cluster_name          = var.cluster_name
  k8s_version           = var.k8s_version
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnets
  node_count            = var.node_count
  instance_type         = var.instance_type
  argo_cd_chart_version = var.argo_cd_chart_version
  argo_cd_version       = var.argo_cd_version
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.0"

  name = var.cluster_name
  cidr = "10.0.0.0/16"

  azs             = ["${var.region}a", "${var.region}b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_dns_hostnames = true
  enable_dns_support   = true
}
