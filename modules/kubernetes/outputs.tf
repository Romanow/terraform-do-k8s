output "loadbalancer_ip" {
  value = data.kubernetes_service.ingress_data.status[0].load_balancer[0].ingress[0].ip
  description = "Load Balancer ip address"
}