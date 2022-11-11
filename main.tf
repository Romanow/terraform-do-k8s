data "digitalocean_kubernetes_versions" "version" {
  version_prefix = "1.24."
}

resource "digitalocean_kubernetes_cluster" "cluster" {
  name    = var.k8s_cluster_name
  region  = var.k8s_cluster_region
  version = data.digitalocean_kubernetes_versions.version.latest_version

  node_pool {
    name       = "worker-pool"
    size       = var.k8s_cluster_size
    node_count = var.k8s_cluster_node_count
    tags       = var.k8s_cluster_tags
  }
}

data "digitalocean_certificate" "certificate" {
  name = var.certificate_name
}

provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.cluster.endpoint
  token                  = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = digitalocean_kubernetes_cluster.cluster.endpoint
    token                  = digitalocean_kubernetes_cluster.cluster.kube_config[0].token
    cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.cluster.kube_config[0].cluster_ca_certificate)
  }
}

resource "helm_release" "ingress" {
  name             = "nginx-stable"
  repository       = "https://helm.nginx.com/stable"
  chart            = "nginx-ingress"
  namespace        = "nginx-ingress"
  create_namespace = true
  timeout          = 600

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/do-loadbalancer-name"
    value = var.loadbalancer_name
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/do-loadbalancer-certificate-id"
    value = data.digitalocean_certificate.certificate.uuid
  }

  set {
    name  = "controller.service.httpsPort.targetPort"
    value = 80
  }
}

data "kubernetes_service" "nginx-ingress" {
  metadata {
    name      = "nginx-stable-nginx-ingress"
    namespace = "nginx-ingress"
  }
  depends_on = [
    helm_release.ingress
  ]
}

resource "digitalocean_record" "base-public" {
  count  = length(var.hostnames)
  domain = var.domain
  name   = var.hostnames[count.index]
  type   = "A"
  ttl    = 300
  value  = data.kubernetes_service.nginx-ingress.status[0].load_balancer[0].ingress[0].ip
}