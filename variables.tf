variable "do_token" {
  type        = string
  description = "DigitalOcean access token"
}

variable "domain" {
  type        = string
  default     = "romanow-alex.ru"
  description = "Base Domain name"
}

variable "certificate_name" {
  type        = string
  default     = "romanow-alex-certificate"
  description = "Certificate name"
}

variable "loadbalancer_name" {
  type        = string
  default     = "loadbalancer"
  description = "Load Balancer name"
}

variable "k8s_cluster_tags" {
  type        = list(string)
  default     = ["k8s-cluster"]
  description = "Cluster tags"
}

variable "k8s_cluster_node_count" {
  type        = number
  default     = 5
  description = "Cluster node count"
}

variable "k8s_cluster_name" {
  type        = string
  default     = "k8s-cluster"
  description = "Cluster name"
}

variable "k8s_cluster_region" {
  type        = string
  default     = "ams3"
  description = "Cluster region"
}

variable "k8s_cluster_size" {
  type        = string
  default     = "s-2vcpu-4gb"
  description = "Node size"
}

variable "hostnames" {
  type        = list(string)
  default     = ["store", "grafana", "kibana", "jaeger"]
  description = "Hostnames"
}