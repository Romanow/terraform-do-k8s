terraform {
  source = "${path_relative_from_include()}/modules/kubernetes"
}

remote_state {
  backend = "local"
  config  = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  k8s_cluster_name       = "k8s-cluster"
  k8s_cluster_region     = "ams3"
  k8s_cluster_size       = "s-2vcpu-4gb"
  k8s_cluster_node_count = "5"
}