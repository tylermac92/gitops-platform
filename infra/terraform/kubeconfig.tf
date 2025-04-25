locals {
  kubeconfig_content = templatefile("${path.module}/kubeconfig.tpl", {
    cluster_name = module.eks_github.cluster_name
    endpoint     = module.eks_github.cluster_endpoint
    ca_data      = module.eks_github.cluster_certificate_authority_data
  })
}

resource "local_sensitive_file" "kubeconfig" {
  filename = "${path.module}/generated-kubeconfig.yaml"
  content  = local.kubeconfig_content
}

output "kubeconfig_path" {
  value = local_sensitive_file.kubeconfig.filename
}
