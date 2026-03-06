output "bastion_ip" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}

output "web1_ip" {
  value = yandex_compute_instance.web1.network_interface.0.ip_address
}

output "web2_ip" {
  value = yandex_compute_instance.web2.network_interface.0.ip_address
}

output "prometheus_ip" {
  value = yandex_compute_instance.prometheus.network_interface.0.ip_address
}

output "grafana_ip" {
  value = yandex_compute_instance.grafana.network_interface.0.nat_ip_address
}

output "load_balancer_ip" {
  value = yandex_alb_load_balancer.web.listener[0].endpoint[0].address[0].external_ipv4_address
}
