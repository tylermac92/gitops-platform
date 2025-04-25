provider "aws" {
  region = var.region
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "20.0.0"
  cluster_name = var.cluster_name
  cluster_version = var.k8s_version
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    default = {
      desired_size = var.node_count
      max_size = var.node_count
      min_size = var.node_count
      instance_type = var.instance_type
    }
  }
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token = data.aws_eks_cluster_auth.auth.token
}

data "aws_eks_cluster_auth" "auth" {
  name = module.eks.cluster_name
}

provider "helm" {
  kubernetes {
    host = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token = data.aws_eks_cluster_auth.auth.token
  }
}

resource "helm_release" "argocd" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  namespace = "argocd"
  version = var.argo_cd_chart_version

  create_namespace = true

  values = [
    yamlencode({
      global = { image = { tag = var.argo_cd_version } }
      configs = { params = { "server.insecure" = "true" } }
      applicationSet = { enabled = true }
    })
  ]
}
